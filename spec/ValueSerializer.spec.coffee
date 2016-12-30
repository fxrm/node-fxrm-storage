
Q = require 'kew'
ValueSerializer = require '../src/ValueSerializer'

class TestValue
    constructor: (@v) ->

describe 'ValueSerializer', ->
    ser = null

    beforeEach ->
        ser = new ValueSerializer(TestValue)

    it 'externalizes null immediately', ->
        value = 'UNSET'
        ser.extern(null).then (v) -> value = v
        expect(value).toBe null

    it 'refuses to externalize mismatching object type', ->
        expect(-> ser.extern {}).toThrow()

    it 'externalizes new value', ->
        value = 'UNSET'
        ser.extern(new TestValue('TESTVAL')).then (v) -> value = v

        expect(value).toBe 'TESTVAL'

    describe 'internalizing a value', ->
        value = null

        beforeEach ->
            value = 'UNSET'
            ser.intern('TESTARBITRARYVAL').then (v) -> value = v

        it 'does so with correct object type', ->
            expect(value).toBe jasmine.any(TestValue)

        it 'does so with correct object value', ->
            expect(value.v).toBe 'TESTARBITRARYVAL'

        it 'is reversible', ->
            value2 = 'UNSET'
            ser.extern(value).then (v) -> value2 = v

            expect(value2).toBe 'TESTARBITRARYVAL'
