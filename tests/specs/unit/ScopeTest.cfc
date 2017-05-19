component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "scope", function() {
            it( "can be instantiated", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                var mockItem = getMockBox().createMock( "fractal.models.Item" );
                expect( new fractal.models.Scope( mockFractal, mockItem ) )
                    .toBeInstanceOf( "fractal.models.Scope" );
            } );

            it( "can get the manager from the scope", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                var mockItem = getMockBox().createMock( "fractal.models.Item" );
                var scope = new fractal.models.Scope( mockFractal, mockItem );
                expect( scope.getManager() ).toBe( mockFractal );
            } );

            it( "can get the resource from the scope", function() {
                var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                var mockItem = getMockBox().createMock( "fractal.models.Item" );
                var scope = new fractal.models.Scope( mockFractal, mockItem );
                expect( scope.getResource() ).toBe( mockItem );
            } );

            describe( "converting data to json", function() {
                describe( "converting a single item", function() {
                    it( "with a callback transformer", function() {
                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        
                        var data = { "foo" = "bar" };
                        var mockItem = getMockBox().createMock( "fractal.models.Item" );
                        mockItem.$( "getTransformer", function( data ) { return data; } );
                        mockItem.$( "getData", data );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( data ) );    
                    } );

                    it( "with a custom transformer", function() {
                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        
                        var data = { "foo" = "bar" };
                        var mockTransformer = getMockBox().createMock( "fractal.models.AbstractTransformer" );
                        mockTransformer.$( "transform", data );

                        var mockItem = getMockBox().createMock( "fractal.models.Item" );
                        mockItem.$( "getTransformer", mockTransformer );
                        mockItem.$( "getData", data );

                        var scope = new fractal.models.Scope( mockFractal, mockItem );
                        expect( scope.toJSON() ).toBe( serializeJSON( data ) );
                    } );
                } );

                describe( "converting a collection", function() {
                    it( "with a callback transformer", function() {
                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockCollection = getMockBox().createMock( "fractal.models.Collection" );
                        mockCollection.$( "getTransformer", function( data ) { return data; } );
                        mockCollection.$( "getData", data );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );    
                    } );

                    it( "with a custom transformer", function() {
                        var mockFractal = getMockBox().createMock( "fractal.models.Manager" );
                        
                        var data = [ { "foo" = "bar" }, { "baz" = "ban" } ];
                        var mockTransformer = getMockBox().createMock( "fractal.models.AbstractTransformer" );
                        mockTransformer.$( "transform" ).$args( { "foo" = "bar" } ).$results( { "foo" = "bar" } );
                        mockTransformer.$( "transform" ).$args( { "baz" = "ban" } ).$results( { "baz" = "ban" } );

                        var mockCollection = getMockBox().createMock( "fractal.models.Collection" );
                        mockCollection.$( "getTransformer", mockTransformer );
                        mockCollection.$( "getData", data );

                        var scope = new fractal.models.Scope( mockFractal, mockCollection );
                        expect( scope.toJSON() ).toBe( serializeJSON( { "data" = data } ) );
                    } );
                } );
            } );
        } );
    }

}