component extends="testbox.system.BaseSpec" {

    variables.simpleCollection = [
        { "foo" = "bar" },
        { "baz" = "ban" }
    ];

    function run() {
        describe( "item resources", function() {
            it( "can get the data from an item resource", function() {
                var item = new fractal.models.resources.Collection( simpleCollection, function() {} );
                expect( item.getData() ).toBe( simpleCollection );
            } );

            describe( "can get the transformer from an item resource", function() {
                it( "works with a closure", function() {
                    var item = new fractal.models.resources.Collection( simpleCollection, function() {} );
                    expect( isClosure( item.getTransformer() ) ).toBeTrue();
                } );

                it( "can work with components", function() {
                    var transformerStub = getMockBox().createStub();
                    var item = new fractal.models.resources.Collection( simpleCollection, transformerStub );
                    expect( item.getTransformer() ).toBe( transformerStub );
                } );
            } );
        } );
    }

}