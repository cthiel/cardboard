@cardboard = (($)->
  appData = {}


  # import external functions
  converter = new Attacklab.showdown.converter()
  createDialog = @CardBoard.dialog.create


  loadDecks = ->
    appData =
      decks     : {}
      decksOrder: []

    $.getJSON "/decks.json", (deckData) ->
      for datum in deckData
        deck = datum.deck
        appData.decks[deck.id] = deck.name
        appData.decksOrder.push deck.id

      # FIXME: There should be a better way to set the board id
      appData.boardId = deckData[0].deck.board_id

      reloadDecksCSS()
      loadCards()

    $('#board')
      .undelegate('.control') # in case loadDecks is called > 1 times
      .delegate('.new_deck',    'click.control', showNewDeckDialog)
      .delegate('.delete_deck', 'click.control', removeDeck)


  loadCards = (cards) ->
    board = appData.board = {}

    $.getJSON "/cards.json", (cardsData) ->

      for datum in cardsData
        deck = datum.card.deck_id
        board[deck] ?= []
        board[deck].push datum.card

      createBoard appData


  reloadDecksCSS = ->
    # Grab and cache original href
    href = @href ?= $('#decks_css').attr 'href'

    href += if href.match /\?/ then '&' else '?'
    href += 'forceReload=' + new Date().valueOf()

    $('#decks_css').attr 'href', href


  fixLinks = ->
    $('#output').delegate 'a', 'click', (e) ->
      if @href
        e.preventDefault()
        e.stopPropagation()
        window.open(@href)


  adjustDeckHeight = (delay) ->
    delay = 300 if typeof delay is not 'number'
    top = $('.cardHolder').offset().top

    clearTimeout(@timer)

    @timer = setTimeout ->
      $('.cardHolder').css {minHeight: $(window).height() - top}
    , delay


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


  unlockScrollbars = ->
    $('html,body').removeClass('scrollX scrollY noScrollX noScrollY')


  bindWindowEvents = ->
    $(window).bind
      mousemove: resetPolling
      resize: adjustDeckHeight


  startPolling = ->
    appData.poll = setInterval ->
      checkStatus() if !appData.dialog
      return
    , 5000


  stopPolling = ->
    clearInterval(appData.poll)
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
      @isNotifyVisible = true
      html = "<span class='notification #{type}'>#{msg}</span>"

      $(html).appendTo($tray).hide().slideDown(300)

    else
      @isNotifyVisible = false


  offline = ->
    console.warn 'offline'
    notify('Cannot contact the CardBoard server', 'error')


  online = ->
    console.info 'online'
    notify(false)


  checkStatus = ->
    # jQuery doesn't have $.head(), but we can use $.ajax()
    _head = (deck) ->
      $.ajax "/#{deck.url}.json",
        type: "HEAD",
        complete: (xhr) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          # run the callback if data has been modified since last check
          deck.func?() if appData[deck.obj]? and appData[deck.obj] != mod
          # save the last modified date
          appData[deck.obj] = mod
        error:   offline
        success: online

    # check both decks & cards for updates
    _head {} = url: "decks", obj: "deckMod", func: loadDecks
    _head {} = url: "cards", obj: "cardMod", func: loadCards

    return


  clearStatus = ->
    appData.cardMod = appData.statusMod = undefined


  createList = (board, deck) ->

    $list = $ "<ul class='cardHolder' id='deck_#{deck}_cards'></ul>"

    if board[deck]
      for card in board[deck]
        tags = card.tag_list.sort().join(', ')
        [card.title, body...] = card.name.split("\n")
        card.markdown = converter.makeHtml(body.join "\n")

        $cardElement = $ """
          <li>
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


  showEditCardDialog = (card) ->
    createDialog
      appData: appData
      title: "Editing card: #{card.title}"
      url:   "/cards/#{card.id}/edit"
      id:    "#edit-form"
      submit:  loadCards

  showNewCardDialog = (deck) ->
    createDialog
      appData: appData
      title: "Add a new card"
      url:   "/cards/new"
      id:    "#new-form"
      deck:  deck
      appear: (opt, form) ->
        $("option", form).map (i, el) ->
          el if el.text.match "^#{opt.deck}$"
        .attr "selected", true
      submit:  loadCards


  showEditDeckDialog = (deck_id, deck_name) ->
    createDialog
      appData: appData
      title: "Editing deck: #{deck_name}"
      url:   "/decks/#{deck_id}/edit"
      id:    "#edit-form"
      submit:  loadDecks

  showNewDeckDialog = () ->
    createDialog
      appData: appData
      title: "Add a new deck"
      url:   "/decks/new"
      id:    "#new-form"
      appear: (opt, form) ->
        $("select", form).val opt.appData.boardId
      submit:  loadDecks


  showCardCloseButton = (e) ->
    $container = $(this)
    $button = $("<b class='close'/>")

    if e.type is 'mouseenter'
      $button.appendTo($container).hide().fadeIn 200
    else
      $('.close', $container).fadeOut 200, ->
        $(this).remove()


  removeCard = (e) ->
    $container = $(this).parent('li')
    cardId = $(this).siblings('.card').data()?['cardId']

    $container.fadeTo(300, 0).delay(300).slideUp 300, ->
      $.ajax
        type: "DELETE"
        url: "/cards/#{cardId}"


  createDeck = (board, deck, headline) ->
    used = if board[deck]?.length then "in_use" else "empty"

    $("<div class='deck #{used}' id='deck_#{deck}'></div>")
      .append("<div class='control delete_deck' title='Remove this deck'>&#215;</div>")
      .append("<h2 class='name'>#{headline}</h2>")
      .append(createList board, deck)

      .data("deck", deck)

      .delegate '.cardHolder', 'dblclick', (e) ->
        e.stopPropagation()
        showNewCardDialog headline if $(e.target)

      .delegate 'h2.name', 'dblclick', (e) ->
        e.stopPropagation()
        showEditDeckDialog $(this).parent().data('deck'), $(this).text()

      .delegate '.card', 'dblclick', (e) ->
        e.stopPropagation()
        showEditCardDialog $(this).parent().data 'card'

      .delegate('.cardHolder>li', 'hover', showCardCloseButton)

      .delegate('.close', 'click', removeCard)



  createBoard = (appData) ->
    # Create a storage fragment
    $decks = $("<div id='decks'/>")

    for deck in appData.decksOrder
      $deck = createDeck(appData.board, deck, appData.decks[deck])
      $decks.append($deck)

    $(".cardHolder", $decks).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "card-placeholder"
      distance: 6
      opacity: 0.7
      revert: 100
      tolerance: "pointer"
      start: (e, drag) ->
        lockScrollbars()
        drag.placeholder.height drag.item.height()
      stop: (e, drag) ->
        unlockScrollbars()
        saveCards e, drag

    $(".deck", $decks)
      .disableSelection()
      .width(95 / appData.decksOrder.length + "%")

    $('#decks').replaceWith($decks)
    adjustDeckHeight(0)


  saveCards = (e, drag) ->
    $item = drag.item
    $card = $item.find '.card'
    cardId = $item.data("card").id
    deckId = $item.parent()[0].id.replace('deck_','')

    $card.addClass "unsaved"

    $.ajax
      type: "PUT"
      url: "cards/#{cardId}"
      data: "card[deck_id]=#{deckId}"
      complete: ->
        $card.removeClass "unsaved"
        clearStatus()


  removeDeck = (event) ->
    $deck = $(event.target).closest(".deck")
    deck_id = $deck.attr("id").replace("deck_","")
    $.ajax
      type: "DELETE"
      url: "/decks/#{deck_id}"
      complete: $deck.effect("drop", 1000, loadDecks)


  init = ->
    bindWindowEvents()
    fixLinks()
    loadDecks()
    startPolling()


  # ## Export selected functions as public ## #
  {init}


)(jQuery)


jQuery ->
  cardboard.init()
