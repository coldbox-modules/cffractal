component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "data serializer", function() {
            it( "serializes the data", function() {
                var serializer = new cffractal.models.serializers.DataSerializer();
                expect( serializer.serialize( { "foo" = "bar" } ) )
                    .toBe( { "data" = { "foo" = "bar" } } );
            } );
        } );
    }
}