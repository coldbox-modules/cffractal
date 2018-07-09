component extends="testbox.system.BaseSpec" {
    function run() {
        describe( "xml serializer", function() {
            beforeEach( function() {
                variables.XMLSerializer = new cffractal.models.serializers.XMLSerializer();
                variables.fractal = new cffractal.models.Manager( XMLSerializer, XMLSerializer, {} );
            } );

            it( "with a callback transformer", function() {
                var book = new tests.resources.Book( {
                    id = 1,
                    title = "To Kill a Mockingbird",
                    year = "1960"
                } );
                var resource = fractal.item( book, function( book ) {
                    return {
                        "id" = book.getId(),
                        "title" = book.getTitle(),
                        "year" = book.getYear()
                    };
                } );

                var scope = fractal.createData( resource );
                expect( scope.convert() ).toMatch( '<root><data><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></data></root>' );
            } );

            it( "with a custom transformer", function() {
                var book = new tests.resources.Book( {
                    id = 1,
                    title = "To Kill a Mockingbird",
                    year = "1960"
                } );

                var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                var scope = fractal.createData( resource );
                expect( scope.convert() ).toMatch( '<root><book><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>' );
            } );

            describe( "has serialization options", function() {
                beforeEach( function() {
                    variables.XMLSerializer = new cffractal.models.serializers.XMLSerializer( sortKeys = false );
                    variables.fractal = new cffractal.models.Manager( XMLSerializer, XMLSerializer, {} );
                });

                it( "can preserve the order of the keys", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960"
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer( sortKeys = false ).setManager( fractal ) );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toMatch( '<root><book><year>1960</year><title>To Kill a Mockingbird</title><id>1</id></book></root>' );
                } );  
            });

            describe( "includes", function() {
                it( "ignores includes by default", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toMatch( '<root><book><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>' );
                } );

                it( "can parse an item with an includes", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource = resource, includes = "author" );
                    expect( scope.convert() ).toMatch( '<root><book><author><name>Harper Lee</name></author><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>' );
                } );

                it( "can parse an item with a default includes", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.DefaultIncludesBookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toMatch( '<root><book><author><name>Harper Lee</name></author><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>' );
                } );

                it( "can parse an item with a nested includes", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 ),
                            country = new tests.resources.Country( {
                                id = 1,
                                name = "United States",
                                planet = new tests.resources.Planet( {
                                    id = 1,
                                    name = "Earth"
                                } )
                            } )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource, "author.country" );
                    var expectedData = '<root><book><author><country><id>1</id><name>United States</name></country><name>Harper Lee</name></author><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>';
                    expect( scope.convert() ).toMatch( expectedData );
                } );

                it( "can parse an item with a deep nested includes", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 ),
                            country = new tests.resources.Country( {
                                id = 1,
                                name = "United States",
                                planet = new tests.resources.Planet( {
                                    id = 1,
                                    name = "Earth"
                                } )
                            } )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource, "author.country.planet" );
                    var expectedData = '<root><book><author><country><id>1</id><name>United States</name><planet><id>1</id><name>Earth</name></planet></country><name>Harper Lee</name></author><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>';
                    expect( scope.convert() ).toMatch( expectedData );
                } );

                it( "can automatically includes the parent when grabbing a nested include", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960",
                        author = new tests.resources.Author( {
                            id = 1,
                            name = "Harper Lee",
                            birthdate = createDate( 1926, 04, 28 ),
                            country = new tests.resources.Country( {
                                id = 1,
                                name = "United States"
                            } )
                        } )
                    } );

                    var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource, "author.country" );
                    var expectedData = '<root><book><author><country><id>1</id><name>United States</name></country><name>Harper Lee</name></author><id>1</id><title>To Kill a Mockingbird</title><year>1960</year></book></root>';
                    expect( scope.convert() ).toMatch( expectedData );
                } );
            } );
        } );
    }
}
