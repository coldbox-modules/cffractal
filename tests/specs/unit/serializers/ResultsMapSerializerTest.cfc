component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "data serializer", function() {
            it( "serializes an item", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "process" ).$args( mockScope ).$results( { "foo" = "bar" } );
                var serializer = new cffractal.models.serializers.ResultsMapSerializer();
                expect( serializer.data( mockItem, mockScope ) )
                    .toBe( { "foo" = "bar" } );
            } );

            it( "serializes a collection", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "process" ).$args( mockScope ).$results( [
                    { "id" = 1, "foo" = "bar" },
                    { "id" = 2, "baz" = "qux" }
                ] );
                var serializer = new cffractal.models.serializers.ResultsMapSerializer();
                expect( serializer.data( mockItem, mockScope ) )
                    .toBe( {
                        "results" = [ 1, 2 ],
                        "resultsMap" = {
                            1 = { "id" = 1, "foo" = "bar" },
                            2 = { "id" = 2, "baz" = "qux" }
                        }
                    } );
            } );

            it( "serializes the metadata", function() {
                var pagingData = { "pagination" = { "maxrows" = 50, "page" = 1, "pages" = 3, "totalRecords" = 112 } };
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockItem = getMockBox().createMock( "cffractal.models.resources.Item" );
                mockItem.$( "getMeta", pagingData, false );
                var serializer = new cffractal.models.serializers.ResultsMapSerializer();
                expect( serializer.meta( mockItem, mockScope ) )
                    .toBe( { "meta" = pagingData } );
            } );
        } );
    }
}
