component extends="testbox.system.BaseSpec" {
    
    function run() {
        describe( "abstract transformers", function() {
            beforeEach( function() {
                variables.transformer = new fractal.models.AbstractTransformer();
            } );
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
                    var item = transformer.item( {}, function() {} );
                    expect( item ).toBeInstanceOf( "fractal.models.Item" );
                } );
            } );
        } );
    }

}