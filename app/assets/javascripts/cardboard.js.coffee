@cardboard = (($)->
  appData = {}

  converter = new Attacklab.showdown.converter()
  createDialog = @CardBoard.dialog.create

  initDecks = ->
    appData =
      decks     : {}
      decksOrder: []

    $.getJSON "/decks.json", (deckData) ->

      for datum in deckData
        deck = datum.deck
        appData.decks[deck.id] = deck.name
        appData.decksOrder.push deck.id

      reloadDecksCSS()
      initCards()

    $('.control.new_deck').click () ->
      showNewDeckDialog()

    $('.control.delete_deck').live "click", removeDeck

  initCards = (cards) ->
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


  watchMouse = ->
    $(document).mousemove ->
      resetPolling()


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

    # check both decks & cards for updates
    _head {} = url: "decks", obj: "deckMod", func: initDecks
    _head {} = url: "cards", obj: "cardMod", func: initCards

    return


  clearStatus = ->
    appData.cardMod = appData.statusMod = undefined


  createList = (board, deck) ->

    $list = $ "<ul class='deck' id='deck_#{deck}_cards'></ul>"

    if board[deck]
      for card in board[deck]
        tags = card.tag_list.sort().join(', ')
        card.markdown = converter.makeHtml(card.name)
        card.title = card.name.split("\n", 1)

        $cardElement = $ """
          <li>
            <div class='box box_#{deck}' data-card-id='#{card.id}'>
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
      func:  initCards

  showNewCardDialog = (deck) ->
    createDialog
      appData: appData
      title: "Add a new card"
      url:   "/cards/new"
      id:    "#new-form"
      deck:  deck
      func:  initCards


  showEditDeckDialog = (deck_id, deck_name) ->
    createDialog
      appData: appData
      title: "Editing deck: #{deck_name}"
      url:   "/decks/#{deck_id}/edit"
      id:    "#edit-form"
      func:  initDecks

  showNewDeckDialog = () ->
    createDialog
      appData: appData
      title: "Add a new deck"
      url:   "/decks/new"
      id:    "#new-form"
      func:  initDecks


  createColumn = (board, deck, headline, width, index) ->
    if board[deck]?.length > 0
      used = " in_use"
    else
      used = " empty"


    $("<div class='column#{used}' id='deck_#{deck}' style='left: #{index * width}%;width: #{width}%;'></div>")
      .append("<div class='control delete_deck' title='Remove this deck'>&#215;</div>")
      .append("<h2 class='name'>#{headline}</h2>")
      .append(createList board, deck)

      .data("deck", deck)

      .delegate '.box', 'dblclick', (e) ->
        e.stopPropagation()
        showEditCardDialog $(this).parent().data 'card'

      .delegate '.deck', 'dblclick', (e) ->
        e.stopPropagation()
        showNewCardDialog headline if $(e.target)

      .delegate 'h2.name', 'dblclick', (e) ->
        e.stopPropagation()
        showEditDeckDialog $(this).parent().data('deck'), $(this).text()


  createBoard = (appData) ->
    $table = $("#board")
    $table.find(".column").remove()

    for deck in appData.decksOrder
      deckColumn = createColumn(appData.board, deck, appData.decks[deck], (95 / appData.decksOrder.length), _i)
      $table.append(deckColumn)

    $(".column>ul", $table).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "box-placeholder"
      distance: 6
      opacity: 0.7
      revert: 100
      tolerance: "pointer"
      start: (e, drag) ->
        lockScrollbars()
        drag.placeholder.height drag.item.height()
      stop: (e, drag) ->
        unlockScrollbars()
        updateCardDeck e, drag

    $(".column", $table)
      .disableSelection()


  updateCardDeck = (e, drag) ->
    $item = drag.item
    $box = $item.find '.box'
    $from_column = drag.placeholder.closest(".column")
    cardId = $item.data("card").id
    deckId = $item.parent()[0].id.replace('deck_','')

    $box.addClass "unsaved"

    $.ajax
      type: "PUT"
      url: "cards/#{cardId}"
      data: "card[deck_id]=#{deckId}"
      complete: ->
        $box.removeClass "unsaved"
        clearStatus()
        initDecks()


  removeDeck = (event) ->
    $deck = $(event.target).closest(".column")
    deck_id = $deck.attr("id").replace("deck_","")

    $deck.addClass("deleted")
    $remainingColumns = $(".column").not(".deleted")
    colWidth = (95 / $remainingColumns.length)

    $.ajax
      type: "DELETE"
      url: "/decks/#{deck_id}"
      complete: () ->
        $deck.fadeOut 200, () -> 
          left = 0
          for column in $remainingColumns
            $(column).animate({left: "#{left}%", width: "#{colWidth}%"}, 600)
            left += colWidth


  init = ->
    initDecks()
    watchMouse()
    fixLinks()
    startPolling()


  # ## Export selected functions as public ## #
  {init}


)(jQuery)


jQuery ->
  cardboard.init()
