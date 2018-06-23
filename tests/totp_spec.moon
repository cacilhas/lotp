local *

TOTP = assert require "otp.totp"

describe "otp", ->
    describe TOTP.__name, ->
        local totp
        specs =
            [{year: 1970, month: 1, day: 1, hour: 0, min: 0, sec: 59}]: 94287082
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}]: 7081804
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 31}]: 14050471
            --[{year: 2009, month: 2, day: 13, hour: 23, min: 31, sec: 30}]: 89005924
            [{year: 2033, month: 5, day: 18, hour: 3, min: 33, sec: 20}]: 69279037
            [{year: 2603, month: 10, day: 11, hour: 11, min: 33, sec: 20}]: 65353130

        setup ->
            totp = TOTP "12345678901234567890"
            totp.last = 0
            totp.post = 0
            totp.length = 8

        describe "#password", ->
            for t, code in pairs specs
                name = os.date "%Y-%m-%d %H:%M:%S", os.time t
                it "should responde #{code} for #{name}", ->
                    assert.are.equal code, totp\password t

            it "should use current UTC date/time by default", ->
                s = spy.on os, "date"
                assert.is.number totp\password!
                assert.spy(s).was.called_with "!*t"

        describe "#digest", ->
            for t, code in pairs specs
                name = os.date "%Y-%m-%d %H:%M:%S", os.time t
                it "should validate #{code} for #{name}", ->
                    assert.is_true totp\digest code, t

            it "should deal with ranges", ->
                totp.last = 1
                totp.post = 1
                t = {year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}
                assert.is_false totp\digest 48150727, t  -- 1m before
                assert.is_true  totp\digest 89731029, t  -- 30s before
                assert.is_true  totp\digest  7081804, t  -- t itself
                assert.is_true  totp\digest 14050471, t  -- 30s after
                assert.is_false totp\digest 44266759, t  -- 1m after

