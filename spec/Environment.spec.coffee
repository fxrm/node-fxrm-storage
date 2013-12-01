
Q = require 'kew'
Environment = require '../src/Environment'

class TestId
class TestValue

describe 'Environment', ->
    env = null
    mockBackend = null

    beforeEach ->
        mockBackend = jasmine.createSpyObj('backend', [ 'find', 'get', 'set', 'create' ])

        env = new Environment({
            mockBackend: mockBackend
        }, {
            mockBackend: [ TestId ]
        })

    it 'externalizes an id', ->
        mockBackend.create.andReturn 'TEST_ID_PROMISE'
        expect(env.extern(new TestId())).toBe 'TEST_ID_PROMISE'

    it 'refuses to externalize a value', ->
        expect(-> env.extern(new TestValue())).toThrow Error
