module.exports =
  activate: ->
    atom.workspaceView.command 'ruby-syntax-replacer:replace', '.editor', ->
      editor = atom.workspaceView.getActivePaneItem()
      replaceSyntax(editor)

replaceSyntax = (editor) ->
  text = editor.getText()
  replaced_text = text.replace /([^:]):(\w+)\s?(\s*)=>\s?(\s*)/g, ($0, $1, $2, $3, $4) ->
    $1 + '' + $2 + ': ' + $3 + "" + $4

  editor.setText(replaced_text)
