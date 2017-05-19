component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "fractal manager", function() {
            it( "can be instantiated", function() {
                expect( new fractal.models.Manager() )
                    .toBeInstanceOf( "fractal.models.Manager" );
            } );

            describe( "create data", function() {
                it( "with callback", function() {
                    var fractal = new fractal.models.Manager();
                    var resource = new fractal.models.Item( { "foo" = "bar" }, function( data ) {
                        return data;
                    } );
                    var rootScope = fractal.createData( resource );
                    expect( rootScope ).toBeInstanceOf( "fractal.models.Scope" );
                } );
            } );
        } );
    }

}