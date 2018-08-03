component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "abstract transformers", function() {
            beforeEach( function() {
                variables.mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                variables.mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                mockFractal.$property( propertyName = "itemSerializer", mock = mockSerializer );
                mockFractal.$property( propertyName = "collectionSerializer", mock = mockSerializer );
                variables.transformer = new cffractal.models.transformers.AbstractTransformer();
                transformer.setManager( mockFractal );
            } );

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

                it( "can add postTransformationCallbacks when creating items", function() {
                    makePublic( transformer, "item", "itemPublic" );
                    var item = prepareMock(
                        transformer.itemPublic(
                            data = {},
                            transformer = function() {},
                            itemCallback = function() {}
                        )
                    );
                    var callbacks = item.$getProperty( "postTransformationCallbacks" );
                    expect( callbacks ).toBeArray();
                    expect( callbacks ).toHaveLength( 1 );
                } );

                it( "creates an item with the transformer serializer if one has been specified", function() {
                    makePublic( transformer, "item", "itemPublic" );
                    var itemA = transformer.itemPublic( {}, function() {} );
                    expect( itemA.getSerializer() ).toBe( mockSerializer );

                    var otherMockSerializer = getMockBox().createMock( "cffractal.models.serializers.SimpleSerializer" );
                    transformer.setSerializer( otherMockSerializer );
                    var itemB = transformer.itemPublic( {}, function() {} );
                    expect( itemB.getSerializer() ).toBe( otherMockSerializer );
                } );

                it( "can create new collections", function() {
                    makePublic( transformer, "collection", "collectionPublic" );
                    var collection = transformer.collectionPublic( [ {}, {} ], function() {} );
                    expect( collection ).toBeInstanceOf( "cffractal.models.resources.Collection" );
                } );

                it( "can add postTransformationCallbacks when creating collections", function() {
                    makePublic( transformer, "collection", "collectionPublic" );
                    var collection = prepareMock(
                        transformer.collectionPublic(
                            data = [ {}, {} ],
                            transformer = function() {},
                            itemCallback = function() {}
                        )
                    );
                    var callbacks = collection.$getProperty( "postTransformationCallbacks" );
                    expect( callbacks ).toBeArray();
                    expect( callbacks ).toHaveLength( 1 );
                } );

                it( "creates an collection with the transformer serializer if one has been specified", function() {
                    makePublic( transformer, "collection", "collectionPublic" );
                    var collectionA = transformer.collectionPublic( [ {}, {} ], function() {} );
                    expect( collectionA.getSerializer() ).toBe( mockSerializer );

                    var otherMockSerializer = getMockBox().createMock( "cffractal.models.serializers.SimpleSerializer" );
                    transformer.setSerializer( otherMockSerializer );
                    var collectionB = transformer.collectionPublic( [ {}, {} ], function() {} );
                    expect( collectionB.getSerializer() ).toBe( otherMockSerializer );
                } );

                it( "can set a itemSerializer and a collectionSerializer separately for a transformer", function() {
                    makePublic( transformer, "item", "itemPublic" );
                    makePublic( transformer, "collection", "collectionPublic" );

                    var itemA = transformer.itemPublic( {}, function() {} );
                    var collectionA = transformer.collectionPublic( [ {}, {} ], function() {} );

                    expect( itemA.getSerializer() ).toBe( mockSerializer );
                    expect( collectionA.getSerializer() ).toBe( mockSerializer );

                    var otherMockSerializer = getMockBox().createMock( "cffractal.models.serializers.SimpleSerializer" );
                    transformer.setItemSerializer( otherMockSerializer );

                    var itemB = transformer.itemPublic( {}, function() {} );
                    var collectionB = transformer.collectionPublic( [ {}, {} ], function() {} );

                    expect( itemB.getSerializer() ).toBe( otherMockSerializer );
                    expect( collectionB.getSerializer() ).toBe( mockSerializer );
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
                mockScope.$( "getExcludes", [] );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                prepareMock( transformer );
                transformer.$( "includeAuthor" ).$args( mockItem ).$results( { "foo" = "bar" } );
                var mockChildScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockChildScope.$( "convert", { "foo" = "bar" } );
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
