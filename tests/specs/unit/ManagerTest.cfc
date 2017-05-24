component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.dataSerializer = getMockBox().createMock( "fractal.models.serializers.DataSerializer" );
        variables.fractal = new fractal.models.Manager( dataSerializer );
    }

    function run() {
        describe( "fractal manager", function() {
            it( "can be instantiated", function() {
                expect( fractal ).toBeInstanceOf( "fractal.models.Manager" );
            } );

            describe( "create data", function() {
                it( "can create a root scope", function() {
                    var resource = new fractal.models.resources.Item( {}, function() {} );
                    var rootScope = fractal.createData( resource );
                    expect( rootScope ).toBeInstanceOf( "fractal.models.Scope" );
                    expect( rootScope.getIdentifier() ).toBe( "" );
                } );

                it( "can create a nested scope", function() {
                    var resource = new fractal.models.resources.Item( {}, function() {} );
                    var nestedScope = fractal.createData( resource, "book" );
                    expect( nestedScope ).toBeInstanceOf( "fractal.models.Scope" );
                    expect( nestedScope.getIdentifier() ).toBe( "book" );
                } );
            } );

            describe( "serializer", function() {
                it( "defaults to a DataSerializer", function() {
                    expect( fractal.getSerializer() )
                        .toBeInstanceOf( "fractal.models.serializers.DataSerializer" );
                } );

                it( "can set a custom serializer", function() {
                    var simpleSerializer = new fractal.models.serializers.SimpleSerializer();
                    fractal.setSerializer( simpleSerializer );
                    expect( fractal.getSerializer() )
                        .toBeInstanceOf( "fractal.models.serializers.SimpleSerializer" );
                } );

                it( "has a helper method to call serialize", function() {
                    var originalData = { "foo" = "bar" };
                    var serializedData = { "data" = originalData };

                    dataSerializer.$( "serialize" )
                        .$args( originalData )
                        .$results( serializedData );

                    fractal.setSerializer( dataSerializer );

                    expect( fractal.serialize( originalData ) )
                        .toBe( serializedData );
                } );

                describe( "parseIncludes", function() {
                    it( "can set a list of includes for the transformed data", function() {
                        fractal.parseIncludes( "author,publisher" );
                        expect( fractal.getIncludes() ).toBe( [ "author", "publisher" ] );    
                    } );

                    it( "automatically includes parent scopes", function() {
                        fractal.parseIncludes( "author.country.planet" );
                        expect( fractal.getIncludes() ).toBe( [ "author.country.planet", "author", "author.country" ] );
                    } );

                    it( "parsing includes multiple times only remembers the last time", function() {
                        fractal.parseIncludes( "author" );
                        fractal.parseIncludes( "publisher" );
                        expect( fractal.getIncludes() ).toBe( [ "publisher" ] );
                    } );
                } );

                describe( "requestedInclude", function() {
                    it( "returns true if an include was request", function() {
                        fractal.parseIncludes( "author" );
                        expect( fractal.requestedInclude( "author" ) ).toBeTrue();
                        expect( fractal.requestedInclude( "publisher" ) ).toBeFalse();
                    } );

                    it( "prepends the scope identifier if passed", function() {
                        fractal.parseIncludes( "author.country" );
                        expect( fractal.requestedInclude( "country", "author" ) ).toBeTrue();
                    } );
                } );
            } );
        } );
    }

}