component extends="testbox.system.BaseSpec" {

    variables.simpleCollection = [
        { "foo" = "bar" },
        { "baz" = "ban" }
    ];

    function run() {
        describe( "collection resources", function() {
            it( "can get the data from an collection resource", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var collection = new cffractal.models.resources.Collection( simpleCollection, function() {}, mockSerializer );
                prepareMock( collection );
                expect( collection.$getProperty( "data" ) ).toBe( simpleCollection );
            } );

            describe( "can get the transformer from an collection resource", function() {
                it( "works with a closure", function() {
                    var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                    var collection = new cffractal.models.resources.Collection( simpleCollection, function() {}, mockSerializer );
                    prepareMock( collection );
                    expect( isClosure( collection.$getProperty( "transformer" ) ) ).toBeTrue();
                } );

                it( "can work with components", function() {
                    var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                    var transformerStub = getMockBox().createStub();
                    var collection = new cffractal.models.resources.Collection( simpleCollection, transformerStub, mockSerializer );
                    prepareMock( collection );
                    expect( collection.$getProperty( "transformer" ) ).toBe( transformerStub );
                } );
            } );
        } );
    }

}