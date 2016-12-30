
Q = require 'kew'

module.exports = class IdentitySerializer
    constructor: (@valueClass, @backend) ->

    extern: (v) ->
        if v is null
            Q.resolve null

        else if !(v instanceof @valueClass)
            throw new Error('value class mismatch')


