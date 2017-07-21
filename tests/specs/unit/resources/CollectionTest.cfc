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

            it( "can add postTransformationCallbacks", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$( "getNullDefaultValue", {} );
                var collection = new cffractal.models.resources.Collection( [
                    { "foo" = "bar" },
                    { "foo" = "baz" },
                    { "foo" = "qux" }
                ], function( item ) {
                    return {
                        "foo" = item.foo & " " & item.foo
                    };
                }, mockSerializer );

                var callbackCalled = false;

                collection.addPostTransformationCallback( function( itemStruct, itemInstance, resource ) {
                    expect( resource ).toBe( collection );
                    expect( itemStruct.foo ).toBe( itemInstance.foo & " " & itemInstance.foo );
                    callbackCalled = true;
                    return itemStruct;
                } );
                
                collection.process( mockScope );

                expect( callbackCalled ).toBeTrue( "Callback was never called" );
            } );

            it( "it never calls the postTransformationCallbacks if the data is null", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$( "getNullDefaultValue", {} );
                var collection = new cffractal.models.resources.Collection(
                    javacast( "null", "" ),
                    function( item ) {
                        return isNull( item ) ? javacast( "null", "" ) : item;
                    },
                    mockSerializer
                );

                var callbackNeverCalled = true;

                collection.addPostTransformationCallback( function( itemStruct, itemInstance ) {
                    callbackNeverCalled = false;
                    return {};
                } );
                
                collection.process( mockScope );

                expect( callbackNeverCalled ).toBeTrue( "Callback should never have been called" );
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