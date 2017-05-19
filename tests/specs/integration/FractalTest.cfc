component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "all the pieces working together", function() {
            beforeEach( function() {
                variables.fractal = new fractal.models.Manager();
            } );

            describe( "converting models", function() {
                describe( "converting items", function() {
                    it( "with a callback transformer", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );
                        var resource = new fractal.models.Item( book, function( book ) {
                            return {
                                "id" = book.getId(),
                                "title" = book.getTitle(),
                                "year" = book.getYear()
                            };
                        } );

                        var json = fractal.createData( resource ).toJson();

                        expect( json ).toBe( '{"year":1960,"title":"To Kill a Mockingbird","id":1}' );     
                    } );

                    it( "with a custom transformer", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );

                        var resource = new fractal.models.Item( book, new tests.resources.BookTransformer() );

                        var json = fractal.createData( resource ).toJson();

                        expect( json ).toBe( '{"year":1960,"title":"To Kill a Mockingbird","id":1}' );
                    } );
                } );
            } );
        } );
    }

}