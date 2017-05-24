component extends="testbox.system.BaseSpec" {
    
    function beforeAll() {
        variables.transformer = new fractal.models.AbstractTransformer();
    }

    function run() {
        describe( "abstract transformers", function() {
            it( "can be instantiated", function() {
                expect( transformer )
                    .toBeInstanceOf( "fractal.models.AbstractTransformer" );
            } );
            
            it( "throws if the `transform()` method has not been implemented", function() {
                expect( function() {
                    transformer.transform();
                } ).toThrow( type = "MethodNotImplemented" );
            } );

            describe( "available includes", function() {
                it( "returns itself after setting the available includes", function() {
                    expect( transformer.setAvailableIncludes( [ "foo" ] ) )
                        .toBe( transformer );
                } );

                it( "can get the available includes", function() {
                    var includes = [ "foo" ];
                    transformer.setAvailableIncludes( includes );
                    expect( transformer.getAvailableIncludes() ).toBe( includes );
                } );
            } );

            describe( "default includes", function() {
                it( "returns itself after setting the default includes", function() {
                    expect( transformer.setDefaultIncludes( [ "foo" ] ) )
                        .toBe( transformer );
                } );

                it( "can get the default includes", function() {
                    var includes = [ "foo" ];
                    transformer.setDefaultIncludes( includes );
                    expect( transformer.getDefaultIncludes() ).toBe( includes );
                } );
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
                expect( transformer.hasIncludes() ).toBeFalse();
                transformer.setDefaultIncludes( [ "author" ] );
                expect( transformer.hasIncludes() ).toBeTrue();
                transformer.setDefaultIncludes( [] );
                expect( transformer.hasIncludes() ).toBeFalse();
                transformer.setAvailableIncludes( [ "publisher" ] );
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

                transformer.setAvailableIncludes( [ "author" ] );
                var includedData = transformer.processIncludes( mockScope, mockItem );
                expect( includedData ).toBe( [ { "foo" = "bar" } ] );
            } );
        } );
    }

}