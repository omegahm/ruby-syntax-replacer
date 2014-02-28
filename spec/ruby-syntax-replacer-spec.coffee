{WorkspaceView} = require 'atom'

describe "ruby-syntax-replacer", ->
  [activationPromise, editor, editorView] = []

  replaceSyntax = (callback) ->
    editorView.trigger 'ruby-syntax-replacer:replace'
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.workspaceView.openSync()

    editorView = atom.workspaceView.getActiveView()
    editor = editorView.getEditor()

    activationPromise = atom.packages.activatePackage('ruby-syntax-replacer')

  describe "when the ruby-syntax-replacer:replace event is triggered", ->
    it "replaces all instances of old ruby syntax with new", ->
      editor.setText """
        {
          :name     => 'Mads Ohm Larsen',
          :age      => '25',
          :position => 'Lead developer'
        }
      """

      replaceSyntax ->
        expect(editor.getText()).toBe """
          {
            name:     'Mads Ohm Larsen',
            age:      '25',
            position: 'Lead developer'
          }
        """

    it "will not replace modules with rockets", ->
      editor.setText """
        begin
        rescue Timeout::Error => e
        end
      """

      replaceSyntax ->
        expect(editor.getText()).toBe """
          begin
          rescue Timeout::Error => e
          end
        """
