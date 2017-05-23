component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "all the pieces working together", function() {
            beforeEach( function() {
                variables.dataSerializer = new fractal.models.serializers.DataSerializer();
                variables.fractal = new fractal.models.Manager( dataSerializer );
            } );

            describe( "converting models", function() {
                describe( "converting items", function() {
                    it( "with a callback transformer", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );
                        var resource = new fractal.models.resources.Item( book, function( book ) {
                            return {
                                "id" = book.getId(),
                                "title" = book.getTitle(),
                                "year" = book.getYear()
                            };
                        } );

                        var scope = fractal.createData( resource );
                        expect( scope.toStruct() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                        expect( scope.toJson() ).toBe( '{"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}}' );
                    } );

                    it( "with a custom transformer", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );

                        var resource = new fractal.models.resources.Item( book, new tests.resources.BookTransformer() );

                        var scope = fractal.createData( resource );
                        expect( scope.toStruct() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                        expect( scope.toJSON() ).toBe( '{"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}}' );
                    } );
                } );

                describe( "converting collections", function() {
                    it( "with a callback transformer", function() {
                        var books = [
                            new tests.resources.Book( {
                                id = 1,
                                title = "To Kill a Mockingbird",
                                year = "1960"
                            } ),
                            new tests.resources.Book( {
                                id = 2,
                                title = "A Tale of Two Cities",
                                year = "1859"
                            } )
                        ];
                        var resource = new fractal.models.resources.Collection( books, function( book ) {
                            return {
                                "id" = book.getId(),
                                "title" = book.getTitle(),
                                "year" = book.getYear()
                            };
                        } );

                        var scope = fractal.createData( resource );
                        expect( scope.toStruct() ).toBe( {"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]} );
                        expect( scope.toJson() ).toBe( '{"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]}' );
                    } );

                    it( "with a custom transformer", function() {
                        var books = [
                            new tests.resources.Book( {
                                id = 1,
                                title = "To Kill a Mockingbird",
                                year = "1960"
                            } ),
                            new tests.resources.Book( {
                                id = 2,
                                title = "A Tale of Two Cities",
                                year = "1859"
                            } )
                        ];

                        var resource = new fractal.models.resources.Collection( books, new tests.resources.BookTransformer() );

                        var scope = fractal.createData( resource );
                        expect( scope.toStruct() ).toBe( {"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]} );
                        expect( scope.toJson() ).toBe( '{"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]}' );
                    } );
                } );
            } );
        } );
    }

}