root = @
$ = root.jQuery

@cardboard ?= {}

@cardboard.app = do ->
  # Board data, which holds the board, decks, & cards
  boardData = {}

  # Misc. data storage
  appData = {}

  # Prepare the imports
  dialog = converter = {}


  # Import external functions to cardboard, after the document.ready
  # (as it's called from init)
  delayedImports = ->
    dialog = root.cardboard.dialog
    converter = new Attacklab.showdown.converter()
    return


  # Load deck data from the server, and arrange it into an object
  loadDecks = ->
    # Initialize/reinitialize boardData
    boardData =
      decks      : {}
      decksOrder : []

    $.getJSON window.location.href + "decks.json", (deckData) ->

      for datum in deckData
        deck = datum.deck
        boardData.decks[deck.id] = deck.name
        boardData.decksOrder.push deck.id

      # FIXME: There should be a better way to set the board id
      boardData.boardId = deckData[0].deck.board_id


  # Load card data from the server, and arrange it into an object
  loadCards = (cards) ->
    # Initialize / reinitialize boardData.board and shorthand it to board
    board = boardData.board = {}

    $.getJSON window.location.href + "cards.json", (cardsData) ->

      for datum in cardsData
        deck = datum.card.deck_id
        board[deck] ?= []
        board[deck].push datum.card


  # Load and make the decks
  makeDecks = ->
    loadDecks().then ->
      reloadDeckStyle()
      makeCards()


  # Load and make the cards
  makeCards = (cards) ->
    loadCards(cards).then ->
      createAllDecks()


  # Reload the generated deck CSS when it may have changed
  reloadDeckStyle = ->
    # Grab and cache original href
    href = appData.deckStyle ?= $('#decks_css').attr 'href'

    # Modify style URI to bust cache
    href += if href.match /\?/ then '&' else '?'
    href += 'forceReload=' + new Date().valueOf()

    # Set to the new location
    $('#decks_css').attr 'href', href


  fixLinks = ->
    $('#output').delegate 'a', 'click', (e) ->
      # Handle the clicked element's href, if it has one
      if @href
        e.preventDefault()
        e.stopPropagation()
        window.open(@href)


  adjustDeckHeight = (delay) ->
    delay = 300 if typeof delay is not 'number'
    top = $('.cardHolder').offset().top

    clearTimeout(appData.timer)

    appData.timer = setTimeout ->
      $('.cardHolder').css {minHeight: $(window).height() - top}
    , delay


  # Work around the browser wanting to modify scrollbars during a move
  lockScrollbars = ->
    $doc = $(document)

    # Find old values
    prev =
      x: $doc.scrollLeft()
      y: $doc.scrollTop()

    # Nudge to see if scrollbars are in place
    scroll =
      x: if $doc.scrollLeft(1).scrollLeft() then 'scrollX' else 'noScrollX'
      y: if $doc.scrollTop(1).scrollTop()   then 'scrollY' else 'noScrollY'

    # Reset doc to previous location
    $doc.scrollLeft(prev.x).scrollTop(prev.y)

    # Apply scrollbar locking classes
    $('body').addClass("#{scroll.x} #{scroll.y}")


  # Allow the browser to do its thing with scrollbars
  unlockScrollbars = ->
    $('html,body').removeClass('scrollX scrollY noScrollX noScrollY')


  bindEvents = ->
    $(window).bind
      mousemove: resetPolling
      resize: adjustDeckHeight

    $('#board')
      .delegate('.new_deck',    'click.control', showNewDeckDialog)
      .delegate('.delete_deck', 'click.control', removeDeck)


  startPolling = ->
    boardData.poll = setInterval ->
      checkStatus() unless boardData.dialog
      return
    , 5000


  stopPolling = ->
    clearInterval(boardData.poll)
    return


  resetPolling = ->
    stopPolling()
    startPolling()
    return


  notify = (msg, type = '') ->
    $tray = $('#notify')

    return if msg is $tray.text()

    $tray.find('.notification').remove()

    if (msg)
      appData.isNotifyVisible = true
      html = "<span class='notification #{type}'>#{msg}</span>"

      $(html).appendTo($tray).hide().slideDown(300)

    else
      appData.isNotifyVisible = false


  offline = ->
    notify('Cannot contact the CardBoard server', 'error')


  online = ->
    notify(false)


  checkStatus = ->
    # jQuery doesn't have $.head(), but we can use $.ajax()
    _head = (deck) ->
      $.ajax window.location.href + "#{deck.url}.json",
        type: "HEAD",
        complete: (xhr) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          # run the callback if data has been modified since last check
          deck.func?() if boardData[deck.obj]? and boardData[deck.obj] != mod
          # save the last modified date
          boardData[deck.obj] = mod
        error:   offline
        success: online

    # check both decks & cards for updates
    _head
      func : makeDecks
      url  : "decks"
      obj  : "deckMod"

    _head
      func : makeCards
      url  : "cards"
      obj  : "cardMod"

    return


  clearStatus = ->
    boardData.cardMod = boardData.statusMod = undefined


  createList = (board, deck) ->

    $list = $ "<ul class='cardHolder' id='deck_#{deck}_cards'></ul>"

    if board[deck]
      for card in board[deck]
        tags = card.tag_list.sort().join(', ')
        [card.title, body...] = card.name.split("\n")
        card.markdown = converter.makeHtml(body.join "\n")

        $cardElement = $ """
          <li id="card_#{card.id}">
            <div class='card card_#{deck}' data-card-id='#{card.id}'>
              <h3 role="title">#{card.title}</h3>
              #{card.markdown}
              #{if tags then '<p>' else ''}#{tags}
            </div>
          </li>
          """

        $cardElement.data "card", card
        $list.append $cardElement

    $list


  showEditCardDialog = (card) =>
    dialog.create
      boardData : boardData
      title     : "Editing card: #{card.title}"
      url       : "cards/#{card.id}/edit"
      id        : "#edit-form"
      submit    : makeCards

  showNewCardDialog = (deck) =>
    dialog.create
      boardData : boardData
      title     : "Add a new card"
      url       : "cards/new"
      id        : "#new-form"
      deck      : deck

      appear: (opt, form) ->
        $("option", form).map (i, el) ->
          el if el.text.match "^#{opt.deck}$"
        .attr "selected", true

      submit: makeCards


  showEditDeckDialog = (deck_id, deck_name) =>
    dialog.create
      boardData : boardData
      title     : "Editing deck: #{deck_name}"
      url       : "decks/#{deck_id}/edit"
      id        : "#edit-form"
      submit    : makeDecks

  showNewDeckDialog = () =>
    dialog.create
      boardData : boardData
      title     : "Add a new deck"
      url       : "decks/new"
      id        : "#new-form"

      appear: (opt, form) ->
        $("select", form).val opt.boardData.boardId

      submit: makeDecks


  showCardCloseButton = (e) ->
    $container = $(@)
    $button    = $("<b class = 'close'/>")

    if e.type is 'mouseenter'
      $button.appendTo($container).hide().fadeIn 200
    else
      $('.close', $container).fadeOut 200, ->
        $(@).remove()


  removeCard = (e) ->
    $container = $(@).parent('li')
    cardId     = $(@).siblings('.card').data()?['cardId']

    $container.fadeTo(300, 0).delay(300).slideUp 300, ->
      $.ajax
        type : "DELETE"
        url  : "cards/#{cardId}"


  # Create a single deck
  createDeck = (board, deck, headline) ->
    used = if board[deck]?.length then "in_use" else "empty"

    $("<div class='deck #{used}' id='deck_#{deck}'/>")
      .append("<div class='control delete_deck' title='Remove this deck'>&#215;</div>")
      .append("<h2 class='name'>#{headline}</h2>")
      .append(createList board, deck)

      .data("deck", deck)

      .delegate '.cardHolder', 'dblclick', (e) ->
        e.stopPropagation()
        showNewCardDialog headline if $(e.target)

      .delegate 'h2.name', 'dblclick', (e) ->
        e.stopPropagation()
        showEditDeckDialog $(@).parent().data('deck'), $(@).text()

      .delegate '.card', 'dblclick', (e) ->
        e.stopPropagation()
        showEditCardDialog $(@).parent().data 'card'

      .delegate('.cardHolder>li', 'hover', showCardCloseButton)

      .delegate('.close', 'click', removeCard)


  # Create all decks
  createAllDecks = ->
    # Create a storage fragment
    $decks = $("<div id='decks'/>")

    for deck in boardData.decksOrder
      $deck = createDeck(boardData.board, deck, boardData.decks[deck])
      $decks.append($deck)

    $(".cardHolder", $decks).sortable
      connectWith : "ul"
      scroll      : false
      placeholder : "card-placeholder"
      distance    : 6
      opacity     : 0.7
      revert      : 100
      tolerance   : "pointer"

      start: (e, drag) ->
        lockScrollbars()
        drag.placeholder.height drag.item.height()

      stop: (e, drag) ->
        unlockScrollbars()
        saveCards e, drag

      update: ->
        $.post(window.location.href + 'cards/sort', $(this).sortable('serialize'))

    $(".deck", $decks)
      .disableSelection()
      .width(95 / boardData.decksOrder.length + "%")

    $('#decks').replaceWith($decks)

    adjustDeckHeight(0)


  saveCards = (e, drag) ->
    $item  = drag.item
    $card  = $item.find '.card'
    cardId = $item.data("card").id
    deckId = $item.parent()[0].id.replace('deck_','').replace('_cards','')

    $card.addClass "unsaved"

    $.ajax
      type : "PUT"
      url  : "cards/#{cardId}"
      data : "card[deck_id]=#{deckId}"
      complete: ->
        $card.removeClass "unsaved"
        clearStatus()

  removeDeck = (event) ->
    $deck   = $(event.target).closest(".deck")
    deck_id = $deck.attr("id").replace("deck_","")

    $.ajax
      type     : "DELETE"
      url      : "decks/#{deck_id}"
      complete : $deck.effect("drop", 1000, makeDecks)


  init = ->
    delayedImports()
    bindEvents()
    fixLinks()
    makeDecks()
    startPolling()


  {init} # Export selected functions as public


jQuery ->
  cardboard.app.init()
