component extends="testbox.system.BaseSpec" {

    variables.simpleCollection = [
        { "foo" = "bar" },
        { "baz" = "ban" }
    ];

    function run() {
        describe( "collection resources", function() {
            it( "can get the data from an collection resource", function() {
                var collection = new cffractal.models.resources.Collection( simpleCollection, function() {} );
                prepareMock( collection );
                expect( collection.$getProperty( "data" ) ).toBe( simpleCollection );
            } );

            describe( "can get the transformer from an collection resource", function() {
                it( "works with a closure", function() {
                    var collection = new cffractal.models.resources.Collection( simpleCollection, function() {} );
                    prepareMock( collection );
                    expect( isClosure( collection.$getProperty( "transformer" ) ) ).toBeTrue();
                } );

                it( "can work with components", function() {
                    var transformerStub = getMockBox().createStub();
                    var collection = new cffractal.models.resources.Collection( simpleCollection, transformerStub );
                    prepareMock( collection );
                    expect( collection.$getProperty( "transformer" ) ).toBe( transformerStub );
                } );
            } );
        } );
    }

}