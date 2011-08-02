@cardboard = (($)->
  appData = {}

  converter = new Attacklab.showdown.converter()

  initDecks = ->
    appData =
      decks     : {}
      decksOrder: []

    $.getJSON "/decks.json", (deckData) ->

      for datum in deckData
        deck = datum.deck
        appData.decks[deck.id] = deck.name
        appData.decksOrder.push deck.id

      initCards()


  initCards = (cards) ->
    board = appData.board = {}

    $.getJSON "/cards.json", (cardsData) ->

      for datum in cardsData
        deck = datum.card.deck_id
        board[deck] ?= []
        board[deck].push datum.card

      createBoard appData


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
        type: "HEAD"
        complete: (xhr, deck) ->
          mod = xhr.getAllResponseHeaders().match(/Last-Modified: (.*)/)[1]
          # run the callback if data has been modified since last check
          deck.func() if appData[deck.obj]? and appData[deck.obj] != mod
          # save the last modified date
          appData[deck.obj] = mod

    # check both decks & cards for updates
    _head {} = url: "decks", obj: "statusMod", func: initDecks
    _head {} = url: "cards",  obj: "cardMod",  func: initCards

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
              <br>#{tags}
            </div>
          </li>
          """

        $cardElement.data "card", card

        $list.append $cardElement

    $list


  showEditCardDialog = (card) ->
    createDialog
      title: "Editing card: #{card.title}"
      url:   "/cards/#{card.id}/edit"
      id:    "#edit-form"


  showNewCardDialog = (deck) ->
    createDialog
      title: "Add a new card"
      url:   "/cards/new"
      id:    "#new-form"
      deck: deck


  # Create a dialog
  createDialog = (opt) ->
    $form = null
    appData.dialog = true

    _closeDialog = ->
      appData.dialog = false
      $dialog.remove()

    _submit = (e) ->
      # Handle the submit via ajax
      $.post($form.attr('action'), $form.serialize())
        .complete ->
          _closeDialog()
          initCards() # Refresh the cards!

      e.preventDefault() # Don't do the default HTML submit action

    # The actual dialog object, stored in a var for reference
    $dialog = $("<div><div class='loading'>Loading...</div></div>").dialog
      title: opt.title
      width: "50%"
      position: [$(window).width() / 4, $(window).height() / 5]
      modal: true

      buttons:
        "Cancel" : _closeDialog
        "Save"   : _submit # this text is replaced later

      close: _closeDialog

      create: ->
        $buttons = $('.ui-dialog-buttonpane', $dialog).hide()

        # Add content from the edit page
        $('.ui-dialog-content', $dialog)
          .load "#{opt.url} #{opt.id}", (data, foo) ->
            $form = $('form', $dialog)

            # Sync button with page's default submit button
            buttonText = $('input[type="submit"]:last',this).val()
            $('button:last', $buttons).text(buttonText) if buttonText

            # If the deck is passed in (new card), select it
            if opt.deck
              $("option", $form).map (i, el) ->
                el if el.text.match "^#{opt.deck}$"
              .attr "selected", true

            $buttons.slideDown 200

            $(opt.id).hide().slideDown 200, ->
              # Preselect the name field
              $('input[type="text"]:first', $dialog).select()

              $form
                # Set the submit handler
                .submit(_submit)
                # Handle enter
                .delegate 'input', 'keydown', (e) ->
                  _submit(e) if e.keyCode == 13


  createColumn = (board, deck, headline) ->
    $("<div class='column' id='deck_#{deck}'></div>")
      .append("<h2 class='name'>#{headline}</h2>")
      .append(createList board, deck)
      .data("deck", deck)
      .delegate 'li', 'dblclick', (e) ->
        showEditCardDialog $(this).data 'card'
      .delegate 'ul', 'dblclick', (e) ->
        # Delegation isn't working right for the UL, oddly, so check it
        showNewCardDialog headline if $(e.target).is('ul')



  createBoard = (appData) ->
    $table = $ "<div id='board'></div>"

    for deck in appData.decksOrder
      deckColumn = createColumn(appData.board, deck, appData.decks[deck])

      $table.append(deckColumn)

    $(".column>ul", $table).sortable
      connectWith: "ul"
      scroll: false
      placeholder: "box-placeholder"
      stop: updateCardDeck
      distance: 6
      opacity: 0.7

    $(".column", $table).disableSelection()

    displayBoard $table
      

  displayBoard = (boardTable) ->
    $("#output").html boardTable


  updateCardDeck = (e, drag) ->
    $item = drag.item
    $box = $item.find '.box'
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


  # Public functions:

  init: ->
    initDecks()
    watchMouse()
    startPolling()


)(jQuery)


jQuery ->
  cardboard.init()

