component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.dataSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
        variables.fractal = new cffractal.models.Manager( dataSerializer );
    }

    function run() {
        describe( "cffractal manager", function() {
            it( "can be instantiated", function() {
                expect( fractal ).toBeInstanceOf( "cffractal.models.Manager" );
            } );

            describe( "create data", function() {
                it( "can create a root scope", function() {
                    var resource = new cffractal.models.resources.Item( {}, function() {} );
                    var rootScope = fractal.createData( resource );
                    expect( rootScope ).toBeInstanceOf( "cffractal.models.Scope" );
                    expect( prepareMock( rootScope ).$getProperty( "identifier" ) ).toBe( "" );
                } );

                it( "can create a nested scope", function() {
                    var resource = new cffractal.models.resources.Item( {}, function() {} );
                    var nestedScope = fractal.createData(
                        resource = resource,
                        identifier = "book"
                    );
                    expect( nestedScope ).toBeInstanceOf( "cffractal.models.Scope" );
                    expect( prepareMock( nestedScope ).$getProperty( "identifier" ) ).toBe( "book" );
                } );
            } );

            describe( "serializer", function() {
                it( "can set a custom serializer", function() {
                    var simpleSerializer = new cffractal.models.serializers.SimpleSerializer();
                    fractal.setSerializer( simpleSerializer );
                    expect( fractal.getSerializer() )
                        .toBeInstanceOf( "cffractal.models.serializers.SimpleSerializer" );
                } );
            } );
        } );
    }

}