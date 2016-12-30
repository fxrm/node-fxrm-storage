
Q = require 'kew'
IdentitySerializer = require '../src/IdentitySerializer'

class TestId

describe 'IdentitySerializer', ->
    mockBackend = null
    ser = null

    beforeEach ->
        mockBackend = jasmine.createSpyObj('backend', [ 'create' ])

        ser = new IdentitySerializer(TestId, mockBackend)

    it 'externalizes null immediately', ->
        value = 'UNSET'
        ser.extern(null).then (v) -> value = v
        expect(value).toBe null

    it 'refuses to externalize mismatching object type', ->
        expect(-> ser.extern {}).toThrow()

    it 'externalizes new entity', ->
        id = new TestId()
        value = 'UNSET'
        id2 = 'UNSET'

        mockBackend.create.andReturn Q.resolve('TESTID')

        ser.extern(id).then (v) -> value = v
        expect(value).toBe 'TESTID'

        expect(mockBackend.create).toHaveBeenCalledWith TestId

        # try again
        value = 'UNSET'
        mockBackend.create.andReturn Q.resolve('ANOTHERTESTID')

        ser.extern(id).then (v) -> value = v
        expect(value).toBe 'TESTID'

        # internalize
        ser.extern(value).then (v) -> id2 = v
        expect(id2).toBe id

    it 'internalizes with correct object type', ->
        id = 'UNSET'
        ser.intern('TESTARBITRARYID').then (v) -> id = v
        expect(id).toBe jasmine.any(TestId)
