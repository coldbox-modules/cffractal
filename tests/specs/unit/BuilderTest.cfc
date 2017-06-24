component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "wirebox integration", function() {
            it( "accepts wirebox slugs for a transformer", function() {
                var builder = prepareMock(
                    new cffractal.models.Builder(
                        new cffractal.models.Manager(
                            new cffractal.models.serializers.SimpleSerializer()
                        )
                    )
                );

                var mockWireBox = createStub().$( "getInstance", function( item ) { return item; } );

                builder.$property( propertyName = "wirebox", mock = mockWireBox );

                builder
                    .item( { id = 1, name = "John" } )
                    .withTransformer( "MyWireBoxSlug" )
                    .toStruct();

                var wireboxCallLog = mockWireBox.$callLog();
                expect( wireboxCallLog ).toBeStruct();
                expect( wireboxCallLog ).toHaveKey( "getInstance" );
                expect( mockWirebox.$once( "getInstance" ) ).toBeTrue();
                var getInstanceCallLog = wireboxCallLog.getInstance;
                expect( getInstanceCallLog ).toBeArray();
                expect( getInstanceCallLog ).toHaveLength( 1 );
                expect( getInstanceCallLog[ 1 ][ 1 ] ).toBe( "MyWireBoxSlug" );
            } );
        } );
    }

}