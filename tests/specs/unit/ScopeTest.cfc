component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "scope", function() {
            it( "can be instantiated", function() {
                var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                expect( new cffractal.models.Scope( mockFractal, mockItem ) )
                    .toBeInstanceOf( "cffractal.models.Scope" );
            } );

            describe( "converting data to struct", function() {
                describe( "converting a single item", function() {
                    it( "with a callback transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                        mockItem.$property( propertyName = "transformer", mock = function( data ) { return data; } );
                        mockItem.$property( propertyName = "data", mock = data );
                        mockItem.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockItem.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockItem );
                        expect( scope.convert() ).toBe( { "data" = data } );
                    } );

                    it( "with a custom transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$property( propertyName = "resourceKey", mock = "data" );
                        mockTransformer.$( "transform", data );
                        mockTransformer.$( "hasIncludes", false );

                        var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                        mockItem.$property( propertyName = "transformer", mock = mockTransformer );
                        mockItem.$property( propertyName = "data", mock = data );
                        mockItem.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockItem.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockItem );
                        expect( scope.convert() ).toBe( { "data" = data } );
                    } );
                } );

                describe( "converting a collection", function() {
                    it( "with a callback transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockCollection = getMockBox().createMock( "cffractal.models.resources.Collection" );
                        mockCollection.$property(
                            propertyName = "transformer",
                            mock = function( data ) { return data; }
                        );
                        mockCollection.$property( propertyName = "data", mock = data );
                        mockCollection.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockCollection.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.convert() ).toBe( { "data" = data } );
                    } );

                    it( "with a custom transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$property( propertyName = "resourceKey", mock = "data" );
                        mockTransformer.$( "transform" ).$args( { "foo" = "bar" } ).$results( { "foo" = "bar" } );
                        mockTransformer.$( "transform" ).$args( { "baz" = "ban" } ).$results( { "baz" = "ban" } );
                        mockTransformer.$( "hasIncludes", false );

                        var mockCollection = getMockBox().createMock( "cffractal.models.resources.Collection" );
                        mockCollection.$property( propertyName = "transformer", mock = mockTransformer );
                        mockCollection.$property( propertyName = "data", mock = data );
                        mockCollection.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockCollection.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.convert() ).toBe( { "data" = data } );
                    } );
                } );
            } );

            describe( "converting data to json", function() {
                describe( "converting a single item", function() {
                    it( "with a callback transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                        mockItem.$property( propertyName = "transformer", mock = function( data ) { return data; } );
                        mockItem.$property( propertyName = "data", mock = data );
                        mockItem.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockItem.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );

                    it( "with a custom transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$property( propertyName = "resourceKey", mock = "data" );
                        mockTransformer.$( "transform", data );
                        mockTransformer.$( "hasIncludes", false );

                        var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                        mockItem.$property( propertyName = "transformer", mock = mockTransformer );
                        mockItem.$property( propertyName = "data", mock = data );
                        mockItem.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockItem.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );
                } );

                describe( "converting a collection", function() {
                    it( "with a callback transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockCollection = getMockBox().createMock( "cffractal.models.resources.Collection" );
                        mockCollection.$property(
                            propertyName = "transformer",
                            mock = function( data ) { return data; }
                        );
                        mockCollection.$property( propertyName = "data", mock = data );
                        mockCollection.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockCollection.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );

                    it( "with a custom transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$property( propertyName = "resourceKey", mock = "data" );
                        mockTransformer.$( "transform" ).$args( { "foo" = "bar" } ).$results( { "foo" = "bar" } );
                        mockTransformer.$( "transform" ).$args( { "baz" = "ban" } ).$results( { "baz" = "ban" } );
                        mockTransformer.$( "hasIncludes", false );

                        var mockCollection = getMockBox().createMock( "cffractal.models.resources.Collection" );
                        mockCollection.$property( propertyName = "transformer", mock = mockTransformer );
                        mockCollection.$property( propertyName = "data", mock = data );
                        mockCollection.$property( propertyName = "meta", mock = {} );

                        var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "data", { "data" = data } );
                        mockCollection.$property( propertyName = "serializer", mock = mockSerializer );

                        var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );

                        var scope = new cffractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );
                } );
            } );

            it( "can create a new scope with a given identifier", function() {
                var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                mockFractal.$( "createData" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                var mockCollection = getMockBox().createMock( "cffractal.models.resources.Collection" );
                var scope = new cffractal.models.Scope( mockFractal, mockItem );

                scope.embedChildScope( "author", mockCollection );

                var callLog = mockFractal.$callLog();
                expect( callLog ).toHaveKey( "createData" );
                var createDataCallLog = mockFractal.$callLog().createData;
                expect( createDataCallLog ).toBeArray();
                expect( createDataCallLog ).toHaveLength( 1 );
                expect( createDataCallLog[ 1 ] ).toHaveKey( "includes" );
                expect( createDataCallLog[ 1 ].includes ).toBe( "" );
                expect( createDataCallLog[ 1 ] ).toHaveKey( "resource" );
                expect( createDataCallLog[ 1 ].resource ).toBe( mockCollection );
                expect( createDataCallLog[ 1 ] ).toHaveKey( "identifier" );
                expect( createDataCallLog[ 1 ].identifier ).toBe( "author" );
            } );

            describe( "parseIncludes", function() {
                it( "can set a list of includes for the transformed data", function() {
                    var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                    var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                    var scope = new cffractal.models.Scope( mockFractal, mockItem );
                    makePublic( scope, "parseIncludes", "parseIncludesPublic" );
                    prepareMock( scope );

                    scope.parseIncludesPublic( "author,publisher" );

                    expect( scope.$getProperty( "includes" ) ).toBe( [ "author", "publisher" ] );
                } );

                it( "automatically includes parent scopes", function() {
                    var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                    var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                    var scope = new cffractal.models.Scope( mockFractal, mockItem, "author.country.planet" );

                    prepareMock( scope );
                    expect( scope.$getProperty( "includes" ) ).toBe( [ "author.country.planet", "author", "author.country" ] );
                } );
            } );

            describe( "requestedInclude", function() {
                it( "returns true if an include was request", function() {
                    var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                    var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                    var scope = new cffractal.models.Scope( mockFractal, mockItem, "author" );

                    expect( scope.requestedInclude( "author" ) ).toBeTrue();
                    expect( scope.requestedInclude( "publisher" ) ).toBeFalse();
                } );

                it( "prepends the scope identifier if passed", function() {
                    var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                    var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );

                    var scope = new cffractal.models.Scope(
                        manager = mockFractal,
                        resource = mockItem,
                        includes = "author.country",
                        identifier = "author"
                    );

                    expect( scope.requestedInclude( "country" ) ).toBeTrue();
                } );

                it( "can handle deeply nested includes", function() {
                    var mockFractal = getMockBox().createMock( "cffractal.models.Manager" );
                    var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );

                    var scope = new cffractal.models.Scope(
                        manager = mockFractal,
                        resource = mockItem,
                        includes = "author.country.provinces.districts.localities",
                        identifier = "author.country.provinces"
                    );

                    expect( scope.requestedInclude( "districts" ) ).toBeTrue();
                } );
            } );
        } );
    }

}
