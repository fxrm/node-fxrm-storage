
Q = require 'kew'

module.exports = class ValueSerializer
    constructor: (@valueClass) ->

    extern: (v) ->
        if v is null
            Q.resolve null

        else if !(v instanceof @valueClass)
            throw new Error('value class mismatch')

        else
            propValues = (propVal for prop, propVal of v)

            if propValues.length isnt 1
                throw new Error('expecting a single property')

            Q.resolve(propValues[0])

    intern: (v) ->

