local *

HOTP = assert require "otp.hotp"

describe "otp", ->
    describe HOTP.__name, ->
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
