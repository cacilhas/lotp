local *


describe "otp", ->
    local TOTP, _test

    setup ->
        TOTP = assert require "otp.totp"
        _test = otp._test.totp

    describe "_internals", ->
        specs =
            [{year: 1970, month: 1, day: 1, hour: 0, min: 0, sec: 59}]: 59
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}]: 1111111109
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 31}]: 1111111111
            [{year: 2009, month: 2, day: 14, hour: 0, min: 31, sec: 30}]: 1234567890
            [{year: 2033, month: 5, day: 18, hour: 3, min: 33, sec: 20}]: 2000000000
            [{year: 2603, month: 10, day: 11, hour: 11, min: 33, sec: 20}]: 20000000000

        describe "cicles", ->
            for t, num in pairs specs
                name = os.date "%Y-%m-%d %H:%M:%S", os.time t
                it "should responde #{num} cicles for #{name}", ->
                    assert.are.equal (math.floor num / 30), _test.cicles 30, t


    describe "totp", ->
        local totp
        specs =
            [{year: 1970, month: 1, day: 1, hour: 0, min: 0, sec: 59}]: 94287082
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}]: 7081804
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 31}]: 14050471
            [{year: 2009, month: 2, day: 14, hour: 0, min: 31, sec: 30}]: 89005924
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

    describe "totp.basexx", ->
        specs =
            [{year: 1970, month: 1, day: 1, hour: 0, min: 0, sec: 59}]: 287082
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 29}]: 81804
            [{year: 2005, month: 3, day: 18, hour: 1, min: 58, sec: 31}]: 050471
            [{year: 2009, month: 2, day: 14, hour: 0, min: 31, sec: 30}]: 005924
            [{year: 2033, month: 5, day: 18, hour: 3, min: 33, sec: 20}]: 279037
            [{year: 2603, month: 10, day: 11, hour: 11, min: 33, sec: 20}]: 353130

        totps =
            bit: TOTP.bit "ooiioooi ooiiooio ooiiooii ooiioioo ooiioioi " ..
                          "ooiioiio ooiioiii ooiiiooo ooiiiooi ooiioooo " ..
                          "ooiioooi ooiiooio ooiiooii ooiioioo ooiioioi " ..
                          "ooiioiio ooiioiii ooiiiooo ooiiiooi ooiioooo", " "
            hex: TOTP.hex "3132333435363738393031323334353637383930"
            base32: TOTP.b32 "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ"
            base64: TOTP.b64 "MTIzNDU2Nzg5MDEyMzQ1Njc4OTA="

        describe "#password", ->
            for totpname, totp in pairs totps
                for t, code in pairs specs
                    name = os.date "%Y-%m-%d %H:%M:%S", os.time t
                    it "should #{totpname} responde #{code} for #{name}", ->
                        assert.are.equal code, totp\password t
