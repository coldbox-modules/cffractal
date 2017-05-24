component extends="testbox.system.BaseSpec" {
    
    function beforeAll() {
        variables.transformer = new fractal.models.transformers.AbstractTransformer();
    }

    function run() {
        describe( "abstract transformers", function() {
            it( "can be instantiated", function() {
                expect( transformer )
                    .toBeInstanceOf( "fractal.models.transformers.AbstractTransformer" );
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
                    expect( item ).toBeInstanceOf( "fractal.models.resources.Item" );
                } );

                it( "can create new collections", function() {
                    makePublic( transformer, "collection", "collectionPublic" );
                    var collection = transformer.collectionPublic( [ {}, {} ], function() {} );
                    expect( collection ).toBeInstanceOf( "fractal.models.resources.Collection" );
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
                var mockScope = getMockBox().createMock( "fractal.models.Scope" );
                mockScope.$( "requestedInclude" ).$args( "author" ).$results( true );
                var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                prepareMock( transformer );
                transformer.$( "includeAuthor" ).$args( mockItem ).$results( { "foo" = "bar" } );
                var mockChildScope = getMockBox().createMock( "fractal.models.Scope" );
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