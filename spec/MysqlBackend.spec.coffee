
require '../src/MysqlBackend'

describe 'MysqlBackend', ->
    storage = null

    beforeEach ->
        storage = new MysqlBackend()
