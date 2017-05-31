component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "simple serializer", function() {
            it( "serializes the data", function() {
                var serializer = new cffractal.models.serializers.SimpleSerializer();
                expect( serializer.serialize( { "foo" = "bar" } ) )
                    .toBe( { "foo" = "bar" } );
            } );
        } );
    }
}