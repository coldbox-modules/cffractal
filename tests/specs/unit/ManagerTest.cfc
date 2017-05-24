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
                    expect( prepareMock( rootScope ).$getProperty( "identifier" ) ).toBe( "" );
                } );

                it( "can create a nested scope", function() {
                    var resource = new fractal.models.resources.Item( {}, function() {} );
                    var nestedScope = fractal.createData(
                        resource = resource,
                        identifier = "book"
                    );
                    expect( nestedScope ).toBeInstanceOf( "fractal.models.Scope" );
                    expect( prepareMock( nestedScope ).$getProperty( "identifier" ) ).toBe( "book" );
                } );
            } );

            describe( "serializer", function() {
                it( "can set a custom serializer", function() {
                    var simpleSerializer = new fractal.models.serializers.SimpleSerializer();
                    fractal.setSerializer( simpleSerializer );
                    expect( prepareMock( fractal ).$getProperty( "serializer" ) )
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
            } );
        } );
    }

}