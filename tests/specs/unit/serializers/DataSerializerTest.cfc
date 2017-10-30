component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "data serializer", function() {
            it( "serializes the data", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "process" ).$args( mockScope ).$results( { "foo" = "bar" } );
                var serializer = new cffractal.models.serializers.DataSerializer();
                expect( serializer.data( mockItem, mockScope ) )
                    .toBe( { "data" = { "foo" = "bar" } } );
            } );

            it( "serializes the metadata", function() {
                var pagingData = { "pagination" = { "maxrows" = 50, "page" = 1, "pages" = 3, "totalRecords" = 112 } };
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "getMeta", pagingData );
                var serializer = new cffractal.models.serializers.DataSerializer();
                expect( serializer.meta( mockItem, mockScope, {} ) )
                    .toBe( { "meta" = pagingData } );
            } );
        } );
    }
}
