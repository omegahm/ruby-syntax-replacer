describe "ruby-syntax-replacer", ->
  [activationPromise, editor, editorView] = []

  replaceSyntax = (callback) ->
    atom.commands.dispatch editorView, 'ruby-syntax-replacer:replace'
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)

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

    it "keeps the whitespace", ->
      editor.setText """
        {
          :name => 'Mads Ohm Larsen',
          :age     => '25',
          :position     => 'Lead developer'
        }
      """

      replaceSyntax ->
        expect(editor.getText()).toBe """
          {
            name: 'Mads Ohm Larsen',
            age:     '25',
            position:     'Lead developer'
          }
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
