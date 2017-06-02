component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "simple serializer", function() {
            it( "serializes the data", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "process" ).$args( mockScope ).$results( { "foo" = "bar" } );
                var serializer = new cffractal.models.serializers.SimpleSerializer();
                expect( serializer.data( mockItem, mockScope ) )
                    .toBe( { "foo" = "bar" } );
            } );

            it( "serializes the metadata", function() {
                var pagingData = { "pagination" = { "maxrows" = 50, "page" = 1, "pages" = 3, "totalRecords" = 112 } };
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "getMeta", pagingData );
                var serializer = new cffractal.models.serializers.SimpleSerializer();
                expect( serializer.meta( mockItem ) )
                    .toBe( { "meta" = pagingData } );
            } );
        } );
    }
}