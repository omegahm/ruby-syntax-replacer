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

    it "replaces inline hashes", ->
      editor.setText """
        {:name => 'Mads'}
      """

      replaceSyntax ->
        expect(editor.getText()).toBe """
          {name: 'Mads'}
        """

    it "replaces selected text in the middle of a hash", ->
      editor.setText """
        {
          :name     => 'Mads Ohm Larsen',
          :age      => '25',
          :position => 'Lead developer'
        }
      """

      editor.setSelectedScreenRange [[1, 0], [1, 99]]

      replaceSyntax ->
        expect(editor.getText()).toBe """
          {
            name:     'Mads Ohm Larsen',
            :age      => '25',
            :position => 'Lead developer'
          }
        """

    it "replaces only selected instances of old ruby syntax with new", ->
      editor.setText """
        {
          :name     => 'Mads Ohm Larsen',
          :age      => '25',
          :position => 'Lead developer'
        }

        {
          :repo => 'https://github.com/omegahm/ruby-syntax-replacer'
        }
      """

      editor.setSelectedScreenRange [[7, 0], [9, 0]]

      replaceSyntax ->
        expect(editor.getText()).toBe """
          {
            :name     => 'Mads Ohm Larsen',
            :age      => '25',
            :position => 'Lead developer'
          }

          {
            repo: 'https://github.com/omegahm/ruby-syntax-replacer'
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
