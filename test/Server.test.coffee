Server = require '../src/Server'

describe 'Server', ->
  server = null

  beforeEach ->
    server = new Server()

  afterEach (done)->
    if server.server
      server.stop ->
        done()
    else
      done()


  it 'constructor', ->
    expected_Port = process.env.PORT || 3000
    Server.assert_Is_Function()
    using new Server(), ->
      assert_Is_Null @.server
      assert_Is_Null @.app
      @.options.assert_Is {}
      @.port.assert_Is expected_Port

  it 'constructor (with options)', ->
    port = 12345
    using new Server(port:port), ->
      @.port.assert_Is 12345

  it 'start_Server', (done)->
    using server, ->
      @.port = 20000 + 5000.random()
      @.setup_Server()
      @.start_Server()
      @.app.assert_Is_Function()
      @.server.assert_Is_Object()
      @.server_Url().add('/ping').GET (data)=>
        data.assert_Contains 'Cannot GET /ping'
        done()

  it 'run', (done)->
    using server, ->
      @.setup_Server()
      @.run(true)
      @.get_JSON '/', (data)->
        data.assert_Is { default: 'route'}
        done()

  # Test functions

  it 'test Api_Hugo', (done)->
    using server, ->
      @.setup_Server()
      @.run(true)
      @.get_JSON '/hugo/files', (data)->
        #data.folder_Hugo.assert_Folder_Exists()
        console.log data
        done()



