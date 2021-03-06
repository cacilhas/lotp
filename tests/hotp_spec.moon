local *

ffi = assert require"ffi", "require LuaJIT"


hex = (str) ->
    str\gsub ".", => string.format "%02x", @\byte!


describe "test helpers", ->
    describe "hex", ->
        it "should return zero", ->
            assert.are.equal "0000000000000000", hex "\0\0\0\0\0\0\0\0"

        it "should return 256", ->
            assert.are.equal "0000000000000100", hex "\0\0\0\0\0\0\1\0"

        it "should deal with a0ed26db964ee800", ->
            assert.are.equal "a0ed26db964ee800", hex "\160\237&\219\150N\232\0"


describe "lotp", ->
    local HOTP, _test

    setup ->
        HOTP = assert require "lotp.hotp"
        _test = lotp._test.hotp

    describe "_internals", ->
        describe "hextou64", ->
            local uint64_t

            setup ->
                uint64_t = ffi.typeof "uint64_t"

            it "should return zero", ->
                data = _test.hextou64 "0000000000000000"
                assert.are.equal uint64_t, ffi.typeof data
                assert.are.equal 0, tonumber data

            it "should return 256", ->
                data = _test.hextou64 "100"
                assert.are.equal uint64_t, ffi.typeof data
                assert.are.equal 256, tonumber data

            it "should deal with a0ed26db964ee800", ->
                data = _test.hextou64 "a0ed26db964ee800"
                assert.are.equal uint64_t, ffi.typeof data
                assert.are.equal 11595967340110342144, tonumber data

        describe "itoa", ->
            specs = {"0000000000000000"
                     "0000000000000001"
                     "0000000000000100"
                     "a0ed26db964ee800"
                     "ffffffffffffffff"}

            for _, value in ipairs specs
                it "should translate uint64_t #{value}", ->
                    assert.are.equal value, hex _test.itoa _test.hextou64 value

                it "should translate string #{value}", ->
                    assert.are.equal value, hex _test.itoa value

            it "should support number", ->
                assert.are.equal "0000000000000100", hex _test.itoa 256

        describe "hmac", ->
            key = "12345678901234567890"

            specs =
                [0]: "cc93cf18508d94934c64b65d8ba7667fb7cde4b0"
                [1]: "75a48a19d4cbe100644e8ac1397eea747a2d33ab"
                [2]: "0bacb7fa082fef30782211938bc1c5e70416ff44"
                [3]: "66c28227d03a2d5529262ff016a1e6ef76557ece"
                [4]: "a904c900a64b35909874b33e61c5938a8e15ed1c"
                [5]: "a37e783d7b7233c083d4f62926c7a25f238d0316"
                [6]: "bc9cd28561042c83f219324d3c607256c03272ae"
                [7]: "a4fb960c0bc06e1eabb804e5b397cdc4b45596fa"
                [8]: "1b3c89f65e6c9e883012052823443f048b4332db"
                [9]: "1637409809a679dc698207310c8c7fc07290d9e5"

            for counter, cipher in pairs specs
                it "should generate #{cipher} for #{counter}", ->
                    assert.are.equal cipher, _test.hmac key, counter

    describe "hotp", ->
        local hotp
        specs =
            [0]: 755224
            [1]: 287082
            [2]: 359152
            [3]: 969429
            [4]: 338314
            [5]: 254676
            [6]: 287922
            [7]: 162583
            [8]: 399871
            [9]: 520489

        setup ->
            hotp = HOTP "12345678901234567890"

        describe "#password", ->
            for step, code in pairs specs
                it "should respond #{code} for #{step}", ->
                    assert.are.equal code, hotp\password step

        describe "#digest", ->
            for step, code in pairs specs
                it "should validate #{code} for #{step}", ->
                    assert.is_true hotp\digest code, step

            it "should follow the sequence", ->
                hotp.currentstep = 0
                assert.is_true hotp\digest specs[0]
                assert.is_true hotp\digest code for _, code in ipairs specs
