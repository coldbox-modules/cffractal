component extends="testbox.system.BaseSpec" {
    
    function beforeAll() {
        variables.mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
        variables.mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
        mockFractal.$property( propertyName = "itemSerializer", mock = mockSerializer );
        mockFractal.$property( propertyName = "collectionSerializer", mock = mockSerializer );
        variables.transformer = new cffractal.models.transformers.AbstractTransformer( mockFractal );
    }

    function run() {
        describe( "abstract transformers", function() {
            it( "can be instantiated", function() {
                expect( transformer )
                    .toBeInstanceOf( "cffractal.models.transformers.AbstractTransformer" );
            } );
            
            it( "throws if the `transform()` method has not been implemented", function() {
                expect( function() {
                    transformer.transform();
                } ).toThrow( type = "MethodNotImplemented" );
            } );

            describe( "resource creation", function() {
                it( "can create new items", function() {
                    makePublic( transformer, "item", "itemPublic" );
                    var item = transformer.itemPublic( {}, function() {} );
                    expect( item ).toBeInstanceOf( "cffractal.models.resources.Item" );
                } );

                it( "can create new collections", function() {
                    makePublic( transformer, "collection", "collectionPublic" );
                    var collection = transformer.collectionPublic( [ {}, {} ], function() {} );
                    expect( collection ).toBeInstanceOf( "cffractal.models.resources.Collection" );
                } );
            } );

            it( "returns true if there are any default or available includes", function() {
                prepareMock( transformer );
                expect( transformer.hasIncludes() ).toBeFalse();
                transformer.$property(
                    propertyName = "defaultIncludes",
                    mock = [ "author" ]
                );
                expect( transformer.hasIncludes() ).toBeTrue();
                transformer.$property(
                    propertyName = "defaultIncludes",
                    mock = []
                );
                expect( transformer.hasIncludes() ).toBeFalse();
                transformer.$property(
                    propertyName = "availableIncludes",
                    mock = [ "publisher" ]
                );
                expect( transformer.hasIncludes() ).toBeTrue();
            } );

            it( "can process the includes of a transformer", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$( "requestedInclude" ).$args( "author" ).$results( true );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                prepareMock( transformer );
                transformer.$( "includeAuthor" ).$args( mockItem ).$results( { "foo" = "bar" } );
                var mockChildScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockChildScope.$( "toStruct", { "foo" = "bar" } );
                mockScope.$( "embedChildScope" ).$args( "author", { "foo" = "bar" } ).$results( mockChildScope );
                transformer.$property(
                    propertyName = "availableIncludes",
                    mock = [ "author" ]
                );

                var includedData = transformer.processIncludes( mockScope, mockItem );
                expect( includedData ).toBe( [ { "foo" = "bar" } ] );
            } );
        } );
    }

}