module.exports =
  activate: ->
    @commands = atom.commands.add 'atom-text-editor',
      'ruby-syntax-replacer:replace': =>
        editor = atom.workspace.getActivePaneItem()
        @_replaceSyntax(editor)

  deactivate: ->
    @commands.dispose()

  _replaceSyntax: (editor) ->
    if editor.getSelectedText()
      text = editor.getSelectedText()
      editor.insertText(@_replaceHashRockets(text))
    else
      text = editor.getText()
      editor.setText(@_replaceHashRockets(text))

  _replaceHashRockets: (text) ->
    text.replace /([^:]|^):(\w+)\s?(\s*)=>\s?(\s*)/g, "$1$2: $3$4"
