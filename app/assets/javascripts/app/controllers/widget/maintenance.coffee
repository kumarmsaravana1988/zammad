class Widget extends App.Controller
  errorCount: 0
  constructor: ->
    super

    App.Event.bind(
      'maintenance'
      (data) =>
        if data.type is 'message'
          @showMessage(data)
        if data.type is 'mode'
          @maintanaceMode(data)
        if data.type is 'app_version'
          @maintanaceAppVersion(data)
        if data.type is 'config_changed'
          @maintanaceConfigChanged(data)
        if data.type is 'restart_auto'
          @maintanaceRestartAuto(data)
        if data.type is 'restart_manual'
          @maintanaceRestartManual(data)
      'maintenance'
    )

  showMessage: (message = {}) =>
    if message.reload
      @disconnectClient()
      button = 'Continue session'
    else
      button = 'Close'

    new App.SessionMessage(
      head:          message.head
      contentInline: message.message
      small:         true
      keyboard:      true
      backdrop:      true
      buttonClose:   true
      buttonSubmit:  button
      forceReload:   message.reload
    )

  maintanaceMode: (data = {}) =>
    return if data.on isnt true
    return if !@authenticateCheck()
    @navigate '#logout'

  #App.Event.trigger('maintenance', {type:'restart_auto'})
  maintanaceRestartAuto: (data) =>
    return if @messageRestartAuto
    @messageRestartAuto = new App.SessionMessage(
      head:         'Zionsoftwares Helpdesk is restarting...'
      message:      'Some system settings have changed, Zionsoftwares Helpdesk is restarting. Please wait until Zionsoftwares Helpdesk is back again.'
      keyboard:     false
      backdrop:     false
      buttonClose:  false
      buttonSubmit: false
      small:        true
      forceReload:  true
    )
    @disconnectClient()
    @checkAvailability()

  #App.Event.trigger('maintenance', {type:'restart_manual'})
  maintanaceRestartManual: (data) =>
    return if @messageRestartManual
    @messageRestartManual = new App.SessionMessage(
      head:         'Zionsoftwares Helpdesk need a restart!'
      message:      'Some system settings have changed, please restart all Zionsoftwares Helpdesk processes! If you want to do this automatically, set environment variable APP___RESTART___CMD="/path/to/your___app___script.sh restart".'
      keyboard:     false
      backdrop:     false
      buttonClose:  false
      buttonSubmit: false
      small:        true
      forceReload:  true
    )
    @disconnectClient()
    @checkAvailability()

  maintanaceConfigChanged: (data) =>
    return if @messageConfigChanged
    @messageConfigChanged = new App.SessionMessage(
      head:         'Config has changed'
      message:      'The configuration of Zionsoftwares Helpdesk has changed, please reload your browser.'
      keyboard:     false
      backdrop:     true
      buttonClose:  false
      buttonSubmit: 'Continue session'
      forceReload:  true
    )

  maintanaceAppVersion: (data) =>
    return if @messageAppVersion
    return if @appVersion is data.app_version
    if !@appVersion
      @appVersion = data.app_version
      return
    @appVersion = data.app_version
    localAppVersion = @appVersion.split(':')
    return if localAppVersion[1] isnt 'true'
    message = =>
      @messageAppVersion = new App.SessionMessage(
        head:         'New Version'
        message:      'A new version of Zionsoftwares Helpdesk is available, please reload your browser.'
        keyboard:     false
        backdrop:     true
        buttonClose:  false
        buttonSubmit: 'Continue session'
        forceReload:  true
      )
    @delay(message, 2000)

  checkAvailability: (delay) =>
    delay = =>
      @ajax(
        id:    'check_availability'
        type:  'get'
        url:   "#{@apiPath}/available"
        success: (data) =>
          if @errorCount is 0
            @checkAvailability()
            return
          @windowReload()
        error: =>
          @errorCount += 1
          @checkAvailability()
      )
    @delay(delay, 2000)

App.Config.set('maintenance', Widget, 'Widgets')
