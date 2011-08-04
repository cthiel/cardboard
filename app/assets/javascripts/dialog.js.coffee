@CardBoard.lib.namespace 'CardBoard.dialog', (exports) ->
  exports.create = (opt) ->
    $form = null
    opt.appData.dialog = true

    _closeDialog = ->
      opt.appData.dialog = false
      $dialog.remove()

    _submit = (e) ->
      # Handle the submit via ajax
      $.post($form.attr('action'), $form.serialize())
        .complete ->
          _closeDialog()
          opt.func?()

      e.preventDefault() # Don't do the default HTML submit action

    # The actual dialog object, stored in a var for reference
    $dialog = $("<div><div class='loading'>Loading...</div></div>").dialog
      title: opt.title
      width: "50%"
      position: [$(document).width() / 4, $(document).height() / 8]
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
              $('textarea,input[type="text"]', $dialog).first().focus()

              $form
                # Set the submit handler
                .submit(_submit)

                # Handle enter
                .delegate 'textarea,input', 'keydown', (e) ->
                  if e.keyCode == 13 and (e.shiftKey or e.ctrlKey)
                    _submit(e)
                .delegate 'input', 'keydown', (e) ->
                  if e.keyCode == 13
                    _submit(e)
