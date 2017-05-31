component extends="testbox.system.BaseSpec" {

    variables.simpleItem = { "foo" = "bar" };

    function run() {
        describe( "item resources", function() {
            it( "can get the data from an item resource", function() {
                var item = new cffractal.models.resources.Item( simpleItem, function() {} );
                prepareMock( item );
                expect( item.$getProperty( "data" ) ).toBe( simpleItem );
            } );

            describe( "can get the transformer from an item resource", function() {
                it( "works with a closure", function() {
                    var item = new cffractal.models.resources.Item( simpleItem, function() {} );
                    prepareMock( item );
                    expect( isClosure( item.$getProperty( "transformer" ) ) ).toBeTrue();
                } );

                it( "can work with components", function() {
                    var transformerStub = getMockBox().createStub();
                    var item = new cffractal.models.resources.Item( simpleItem, transformerStub );
                    prepareMock( item );
                    expect( item.$getProperty( "transformer" ) ).toBe( transformerStub );
                } );
            } );
        } );
    }

}