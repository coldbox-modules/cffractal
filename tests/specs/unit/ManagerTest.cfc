component extends="testbox.system.BaseSpec" {

    function beforeAll() {
        variables.dataSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
        variables.fractal = new cffractal.models.Manager( dataSerializer, dataSerializer );
    }

    function run() {
        describe( "cffractal manager", function() {
            it( "can be instantiated", function() {
                expect( fractal ).toBeInstanceOf( "cffractal.models.Manager" );
            } );

            describe( "create data", function() {
                it( "can create a root scope", function() {
                    var resource = fractal.item( {}, function() {} );
                    var rootScope = fractal.createData( resource );
                    expect( rootScope ).toBeInstanceOf( "cffractal.models.Scope" );
                    expect( prepareMock( rootScope ).$getProperty( "identifier" ) ).toBe( "" );
                } );

                it( "can create a nested scope", function() {
                    var resource = fractal.item( {}, function() {} );
                    var nestedScope = fractal.createData(
                        resource = resource,
                        identifier = "book"
                    );
                    expect( nestedScope ).toBeInstanceOf( "cffractal.models.Scope" );
                    expect( prepareMock( nestedScope ).$getProperty( "identifier" ) ).toBe( "book" );
                } );
            } );

            describe( "serializer", function() {
                it( "can set a custom item serializer", function() {
                    var simpleSerializer = new cffractal.models.serializers.SimpleSerializer();
                    fractal.setItemSerializer( simpleSerializer );
                    expect( fractal.getItemSerializer() )
                        .toBeInstanceOf( "cffractal.models.serializers.SimpleSerializer" );
                } );

                it( "can set a custom collection serializer", function() {
                    var resultsMapSerializer = new cffractal.models.serializers.ResultsMapSerializer();
                    fractal.setCollectionSerializer( resultsMapSerializer );
                    expect( fractal.getCollectionSerializer() )
                        .toBeInstanceOf( "cffractal.models.serializers.ResultsMapSerializer" );
                } );
            } );
        } );
    }

}