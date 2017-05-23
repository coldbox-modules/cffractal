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
                it( "with callback", function() {
                    var resource = new fractal.models.resources.Item( { "foo" = "bar" }, function( data ) {
                        return data;
                    } );
                    var rootScope = fractal.createData( resource );
                    expect( rootScope ).toBeInstanceOf( "fractal.models.Scope" );
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
            } );
        } );
    }

}