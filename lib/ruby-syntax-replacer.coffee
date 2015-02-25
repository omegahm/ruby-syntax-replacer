module.exports =
  activate: ->
    atom.commands.add 'atom-text-editor', 'ruby-syntax-replacer:replace', ->
      editor = atom.workspace.getActivePaneItem()
      replaceSyntax(editor)

replaceSyntax = (editor) ->
  if editor.getSelectedText()
    text = editor.getSelectedText()
    editor.insertText(replaceHashRockets(text))
  else
    text = editor.getText()
    editor.setText(replaceHashRockets(text))

replaceHashRockets = (text) ->
  text.replace /([^:]|^):(\w+)\s?(\s*)=>\s?(\s*)/g, ($0, $1, $2, $3, $4) ->
    $1 + '' + $2 + ': ' + $3 + '' + $4
