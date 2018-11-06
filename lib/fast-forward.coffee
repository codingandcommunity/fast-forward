FastForwardView = require './fast-forward-view'
{CompositeDisposable, Emitter} = require 'atom'
npm = require '../../npm-plus/lib/npm-plus.js'

module.exports = FastForward =
  fastForwardView: null
  modalPanel: null
  subscriptions: null
  emitter: null

  activate: (state) ->
    # Construct Emitter, then pass Emitter into construct fastForwardView.
    @emitter = new Emitter()
    @fastForwardView = new FastForwardView(state.fastForwardViewState, @emitter)

    # Create a panel for the plugin, visible by default
    @modalPanel = atom.workspace.addRightPanel(item: @fastForwardView.getElement(), visible: true)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable()

    # Register command that toggles this view
    @subscriptions.add(atom.commands.add('atom-workspace', {'fast-forward:toggle': () => @toggle()}))
    @subscriptions.add(atom.commands.add('atom-workspace', {'fast-forward:installdependencies': () =>  @installDependencies()}))

    @emitter.on 'toggle-button-event', => @toggle()
    @emitter.on 'install-button-event', => @installDependencies()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @emitter.dispose()
    @fastForwardView.destroy()

  serialize: ->
    fastForwardViewState: @fastForwardView.serialize()

  toggle: ->
    console.log 'FastForward was toggled!'
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  installDependencies: ->
    npm("install")  #this calls the npm function to install the depencies, this calls the function and that works but the fucntion fails rn
