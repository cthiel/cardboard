describe "Foo", ->

    it "it is not bar", ->
        v = new Foo()

        expect(v.bar()).toEqual(false)

describe "Bar", ->

    it "it is not foo", ->
        v = new Bar()

        expect(v.foo()).toEqual(false)
