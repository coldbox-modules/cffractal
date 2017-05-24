component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "scope", function() {
            it( "can be instantiated", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                expect( new fractal.models.Scope( mockFractal, mockItem ) )
                    .toBeInstanceOf( "fractal.models.Scope" );
            } );

            describe( "converting data to struct", function() {
                describe( "converting a single item", function() {
                    it( "with a callback transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                        mockItem.$( "getTransformer", function( data ) { return data; } );
                        mockItem.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toStruct() ).toBe( { "data" = data } );
                    } );

                    it( "with a custom transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockTransformer = getMockBox().createMock( "fractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$( "transform", data );
                        mockTransformer.$( "hasIncludes", false );

                        var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                        mockItem.$( "getTransformer", mockTransformer );
                        mockItem.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toStruct() ).toBe( { "data" = data } );
                    } );
                } );

                describe( "converting a collection", function() {
                    it( "with a callback transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockCollection = getMockBox().createMock( "fractal.models.resources.Collection" );
                        mockCollection.$( "getTransformer", function( data ) { return data; } );
                        mockCollection.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toStruct() ).toBe( { "data" = data } );
                    } );

                    it( "with a custom transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockTransformer = getMockBox().createMock( "fractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$( "transform" ).$args( { "foo" = "bar" } ).$results( { "foo" = "bar" } );
                        mockTransformer.$( "transform" ).$args( { "baz" = "ban" } ).$results( { "baz" = "ban" } );
                        mockTransformer.$( "hasIncludes", false );

                        var mockCollection = getMockBox().createMock( "fractal.models.resources.Collection" );
                        mockCollection.$( "getTransformer", mockTransformer );
                        mockCollection.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toStruct() ).toBe( { "data" = data } );
                    } );
                } );
            } );

            describe( "converting data to json", function() {
                describe( "converting a single item", function() {
                    it( "with a callback transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                        mockItem.$( "getTransformer", function( data ) { return data; } );
                        mockItem.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );    
                    } );

                    it( "with a custom transformer", function() {
                        var data = { "foo" = "bar" };
                        var mockTransformer = getMockBox().createMock( "fractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$( "transform", data );
                        mockTransformer.$( "hasIncludes", false );

                        var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                        mockItem.$( "getTransformer", mockTransformer );
                        mockItem.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );
                } );

                describe( "converting a collection", function() {
                    it( "with a callback transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockCollection = getMockBox().createMock( "fractal.models.resources.Collection" );
                        mockCollection.$( "getTransformer", function( data ) { return data; } );
                        mockCollection.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection ); new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );    
                    } );

                    it( "with a custom transformer", function() {
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockTransformer = getMockBox().createMock( "fractal.models.transformers.AbstractTransformer" );
                        mockTransformer.$( "transform" ).$args( { "foo" = "bar" } ).$results( { "foo" = "bar" } );
                        mockTransformer.$( "transform" ).$args( { "baz" = "ban" } ).$results( { "baz" = "ban" } );
                        mockTransformer.$( "hasIncludes", false );

                        var mockCollection = getMockBox().createMock( "fractal.models.resources.Collection" );
                        mockCollection.$( "getTransformer", mockTransformer );
                        mockCollection.$( "getData", data );

                        var mockSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
                        mockSerializer.$( "serialize", { "data" = data } );

                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        mockFractal.$( "getSerializer", mockSerializer );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );
                } );
            } );

            it( "passes on to the manager to check for a requested include", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                mockFractal.$( "requestedInclude" ).$args( "country", "author" ).$results( true );
                var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                var scope = new fractal.models.Scope( mockFractal, mockItem, "author" );
                expect( scope.requestedInclude( "country" ) ).toBe( true );
            } );

            it( "can create a new scope with a given identifier", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                var mockItem = getMockBox().createMock( "fractal.models.resources.Item" );
                var mockCollection = getMockBox().createMock( "fractal.models.resources.Collection" );
                var scope = new fractal.models.Scope( mockFractal, mockItem );

                var childScope = scope.embedChildScope( "author", mockCollection );

                prepareMock( childScope );
                expect( childScope.$getProperty( "resource" ) ).toBe( mockCollection );
                expect( childScope.$getProperty( "identifier" ) ).toBe( "author" );
            } );
        } );
    }

}