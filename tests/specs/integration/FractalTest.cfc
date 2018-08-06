component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "all the pieces working together", function() {
            beforeEach( function() {
                variables.dataSerializer = new cffractal.models.serializers.DataSerializer();
                variables.fractal = new cffractal.models.Manager( dataSerializer, dataSerializer, {} );
            } );

            describe( "null default values", function() {
                it( "returns the null default value if the resource is null for items", function() {
                    var resource = fractal.item( javacast( "null", "" ), function( doesntMatter ) {
                        return {
                            "should" = "never",
                            "get" = "called"
                        };
                    } );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toBe( {"data":{}} );
                } );

                it( "returns an empty array if the resource is null for collections", function() {
                    var resource = fractal.collection( javacast( "null", "" ), function( doesntMatter ) {
                        return {
                            "should" = "never",
                            "get" = "called"
                        };
                    } );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toBe( {"data":[]} );
                } );

                it( "returns the null default value if the transformed result is null", function() {
                    var book = new tests.resources.Book( {
                        id = 1,
                        title = "To Kill a Mockingbird",
                        year = "1960"
                    } );

                    var resource = fractal.item( book, function( book ) {
                        return javacast( "null", "" );
                    } );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toBe( {"data":{}} );
                } );

                it( "returns the null default value if the result from a postTransformationCallback is null for items", function() {
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

                    resource.addPostTransformationCallback( function( book ) {
                        return javacast( "null", "" );
                    } );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toBe( {"data":{}} );
                } );

                it( "returns the null default value if the result from a postTransformationCallback is null for collections", function() {
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
                    var resource = fractal.collection( books, function( book ) {
                        return {
                            "id" = book.getId(),
                            "title" = book.getTitle(),
                            "year" = book.getYear()
                        };
                    } );

                    resource.addPostTransformationCallback( function( book ) {
                        return javacast( "null", "" );
                    } );

                    var scope = fractal.createData( resource );
                    expect( scope.convert() ).toBe( {"data":[{},{}]} );
                } );

                it( "returns the null default value for an include that returns null", function() {
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

                    var resource = fractal.item( book, new tests.resources.BookWithNullIncludesTransformer().setManager( fractal ) );

                    var scope = fractal.createData( resource = resource, includes = "author" );
                    expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1,"author":{"data":{}}}} );
                } );
            } );

            describe( "converting models", function() {
                describe( "converting items", function() {
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
                        expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                    } );

                    it( "with a custom transformer", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );

                        var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                        var scope = fractal.createData( resource );
                        expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                    } );

                    it( "can use a special serializer for a resource", function() {
                        var book = new tests.resources.Book( {
                            id = 1,
                            title = "To Kill a Mockingbird",
                            year = "1960"
                        } );

                        var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );
                        resource.setSerializer( new cffractal.models.serializers.SimpleSerializer() );

                        var scope = fractal.createData( resource );
                        expect( scope.convert() ).toBe( {"year":1960,"title":"To Kill a Mockingbird","id":1} );
                    } );

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
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
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
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1,"author":{"data":{"name":"Harper Lee"}}}} );
                        } );

                        it( "can handle primitives returned directly from an include", function() {
                            var book = new tests.resources.Book( {
                                id = 1,
                                title = "To Kill a Mockingbird",
                                year = "1960",
                                author = new tests.resources.Author( {
                                    id = 1,
                                    name = "Harper Lee",
                                    birthdate = createDate( 1926, 04, 28 )
                                } ),
                                isClassic = false
                            } );

                            var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                            var scope = fractal.createData( resource = resource, includes = "isClassic" );
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1,"isClassic":false}} );
                        } );

                        it( "removes any availableIncludes keys that are not included from the serialized output", function() {
                            var book = new tests.resources.Book( {
                                id = 1,
                                title = "To Kill a Mockingbird",
                                year = "1960",
                                author = new tests.resources.Author( {
                                    id = 1,
                                    name = "Harper Lee",
                                    birthdate = createDate( 1926, 04, 28 )
                                } ),
                                isClassic = false
                            } );

                            var resource = fractal.item( book, new tests.resources.BookTransformer().setManager( fractal ) );

                            var scope = fractal.createData( resource = resource );
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                        } );

                        it( "can parse an item with a default includes", function() {
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

                            var resource = fractal.item( book, new tests.resources.DefaultIncludesBookTransformer().setManager( fractal ) );

                            var scope = fractal.createData( resource );
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1,"author":{"data":{"name":"Harper Lee"}}}} );
                        } );

                        it( "can use a special serializer for an include", function() {
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

                            var resource = fractal.item( book, new tests.resources.SpecializedSerializerBookTransformer().setManager( fractal ) );

                            var scope = fractal.createData( resource );
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1,"author":{"name":"Harper Lee"}}} );
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
                            var expectedData = {
                                "data" = {
                                    "year" = 1960,
                                    "title" = "To Kill a Mockingbird",
                                    "id" = 1,
                                    "author" = {
                                        "data" = {
                                            "name" = "Harper Lee",
                                            "country" = {
                                                "data" = {
                                                    "id" = 1,
                                                    "name" = "United States"
                                                }
                                            }
                                        }
                                    }
                                }
                            };
                            expect( scope.convert() ).toBe( expectedData );
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
                            var expectedData = {
                                "data" = {
                                    "year" = 1960,
                                    "title" = "To Kill a Mockingbird",
                                    "id" = 1,
                                    "author" = {
                                        "data" = {
                                            "name" = "Harper Lee",
                                            "country" = {
                                                "data" = {
                                                    "id" = 1,
                                                    "name" = "United States",
                                                    "planet" = {
                                                        "data" = {
                                                            "id" = 1,
                                                            "name" = "Earth"
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            };
                            expect( scope.convert() ).toBe( expectedData );
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
                            var expectedData = {
                                "data" = {
                                    "year" = 1960,
                                    "title" = "To Kill a Mockingbird",
                                    "id" = 1,
                                    "author" = {
                                        "data" = {
                                            "name" = "Harper Lee",
                                            "country" = {
                                                "data" = {
                                                    "id" = 1,
                                                    "name" = "United States"
                                                }
                                            }
                                        }
                                    }
                                }
                            };
                            expect( scope.convert() ).toBe( expectedData );
                        } );

                        it( "makes the scoped includes available in a closure transformer", function() {
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

                            var resource = fractal.item( book, function( book, includes ) {
                                expect( isNull( includes ) ).toBeFalse( "includes should not be null" );
                                expect( includes ).toBeArray();
                                expect( includes ).toHaveLength( 2 );
                                expect( includes ).toBe( [ "year", "author" ] );
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                includes = "year,author.name"
                            ).convert();
                        } );

                        it( "passes an empty array for scoped includes and all includes if there are no includes", function() {
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

                            var resource = fractal.item( book, function( book, includes ) {
                                expect( isNull( includes ) ).toBeFalse( "includes should not be null" );
                                expect( includes ).toBeArray();
                                expect( includes ).toBeEmpty();
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                includes = ""
                            ).convert();
                        } );

                        it( "makes the full includes available in a closure transformer", function() {
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

                            var resource = fractal.item( book, function( book, includes, excludes, allIncludes ) {
                                expect( isNull( allIncludes ) ).toBeFalse( "allIncludes should not be null" );
                                expect( allIncludes ).toBeArray();
                                expect( allIncludes ).toHaveLength( 3 );
                                expect( allIncludes ).toBe( [ "year", "author.name", "author" ] );
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                includes = "year,author.name"
                            ).convert();
                        } );

                        it( "makes the scoped includes available in a component transformer", function() {
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

                            var bookTransformer = createMock( "tests.resources.BookTransformer" ).setManager( fractal );
                            bookTransformer.$( "transform", {} );
                            var authorTransformer = createMock( "tests.resources.AuthorTransformer" ).setManager( fractal );
                            authorTransformer.$( "transform", {} );
                            bookTransformer.$property( propertyName = "authorTransformer", mock = authorTransformer );
                            var resource = fractal.item( book, bookTransformer );
                            fractal.createData(
                                resource = resource,
                                includes = "year,author.name"
                            ).convert();

                            // Book Transformer
                            var callLog = bookTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 2, "At least two arguments should be passed to the transform function" );
                            var scopedIncludes = firstCall[ 2 ];
                            expect( scopedIncludes ).toBeArray();
                            expect( scopedIncludes ).toHaveLength( 2 );
                            expect( scopedIncludes ).toBe( [ "year", "author" ] );

                            // Author Transformer
                            var callLog = authorTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 2, "At least two arguments should be passed to the transform function" );
                            var scopedIncludes = firstCall[ 2 ];
                            expect( scopedIncludes ).toBeArray();
                            expect( scopedIncludes ).toHaveLength( 1 );
                            expect( scopedIncludes ).toBe( [ "name" ] );
                        } );

                        it( "makes the full includes available in a component transformer", function() {
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

                            var bookTransformer = createMock( "tests.resources.BookTransformer" ).setManager( fractal );
                            bookTransformer.$( "transform", {} );
                            var authorTransformer = createMock( "tests.resources.AuthorTransformer" ).setManager( fractal );
                            authorTransformer.$( "transform", {} );
                            bookTransformer.$property( propertyName = "authorTransformer", mock = authorTransformer );
                            var resource = fractal.item( book, bookTransformer );
                            fractal.createData(
                                resource = resource,
                                includes = "year,author.name"
                            ).convert();

                            // Book Transformer
                            var callLog = bookTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 4, "At least four arguments should be passed to the transform function" );
                            var allIncludes = firstCall[ 4 ];
                            expect( allIncludes ).toBeArray();
                            expect( allIncludes ).toHaveLength( 3 );
                            expect( allIncludes ).toBe( [ "year", "author.name", "author" ] );

                            // Author Transformer
                            var callLog = authorTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 4, "At least four arguments should be passed to the transform function" );
                            var allIncludes = firstCall[ 4 ];
                            expect( allIncludes ).toBeArray();
                            expect( allIncludes ).toHaveLength( 3 );
                            expect( allIncludes ).toBe( [ "year", "author.name", "author" ] );
                        } );
                    } );

                    describe( "excludes", function() {
                        it( "can ignore a default include", function() {
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

                            var scope = fractal.createData(
                                resource = resource,
                                excludes = "author"
                            );
                            expect( scope.convert() ).toBe( {"data":{"year":1960,"title":"To Kill a Mockingbird","id":1}} );
                        } );

                        it( "can ignore a nested default include", function() {
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

                            var resource = fractal.item( book, new tests.resources.DefaultIncludesBookTransformer( withDefaultCountry = true ).setManager( fractal ) );

                            var scope = fractal.createData(
                                resource = resource,
                                excludes = "author.country"
                            );
                            var expectedData = {
                                "data" = {
                                    "year" = 1960,
                                    "title" = "To Kill a Mockingbird",
                                    "id" = 1,
                                    "author" = {
                                        "data" = {
                                            "name" = "Harper Lee"
                                        }
                                    }
                                }
                            };
                            expect( scope.convert() ).toBe( expectedData );
                        } );

                        it( "removes the excluded keys from the serialized output with a closure transformer", function() {
                            var planet = new tests.resources.Planet( {
                                id = 1,
                                name = "Mercury"
                            } );

                            var resource = fractal.item( planet, function( planet ) {
                                return {
                                    id = planet.getId(),
                                    name = planet.getName()
                                };
                            } );

                            var scope = fractal.createData(
                                resource = resource,
                                excludes = "name"
                            );

                            expect( scope.convert() ).toBe( { "data" = { "id" = 1 } } );
                        } );

                        it( "removes the excluded keys from the serialized output with a component transformer", function() {
                            var planet = new tests.resources.Planet( {
                                id = 1,
                                name = "Mercury"
                            } );

                            var resource = fractal.item(
                                planet,
                                new tests.resources.PlanetTransformer()
                            );

                            var scope = fractal.createData(
                                resource = resource,
                                excludes = "name"
                            );

                            expect( scope.convert() ).toBe( { "data" = { "id" = 1 } } );
                        } );

                        it( "removes the nested excluded keys from the serialized output", function() {
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

                            var resource = fractal.item(
                                book,
                                new tests.resources.DefaultIncludesBookTransformer( withDefaultCountry = true ).setManager( fractal )
                            );

                            var scope = fractal.createData(
                                resource = resource,
                                excludes = "author.country.id"
                            );

                            var expectedData = {
                                "data" = {
                                    "year" = 1960,
                                    "title" = "To Kill a Mockingbird",
                                    "id" = 1,
                                    "author" = {
                                        "data" = {
                                            "name" = "Harper Lee",
                                            "country" = {
                                                "data" = {
                                                    "name" = "United States"
                                                }
                                            }
                                        }
                                    }
                                }
                            };
                            expect( scope.convert() ).toBe( expectedData );
                        } );

                        it( "makes the scoped excludes available in a closure transformer", function() {
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

                            var resource = fractal.item( book, function( book, includes, excludes ) {
                                expect( isNull( excludes ) ).toBeFalse( "excludes should not be null" );
                                expect( excludes ).toBeArray();
                                expect( excludes ).toHaveLength( 1 );
                                expect( excludes ).toBe( [ "year" ] );
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                excludes = "year,author.name"
                            ).convert();
                        } );

                        it( "passes an empty array for scoped excludes and all excludes if there are no excludes", function() {
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

                            var resource = fractal.item( book, function( book, includes, excludes ) {
                                expect( isNull( excludes ) ).toBeFalse( "excludes should not be null" );
                                expect( excludes ).toBeArray();
                                expect( excludes ).toBeEmpty();
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                excludes = ""
                            ).convert();
                        } );

                        it( "makes the full excludes available in a closure transformer", function() {
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

                            var resource = fractal.item( book, function( book, includes, excludes, allIncludes, allExcludes ) {
                                expect( isNull( allExcludes ) ).toBeFalse( "allExcludes should not be null" );
                                expect( allExcludes ).toBeArray();
                                expect( allExcludes ).toHaveLength( 2 );
                                expect( allExcludes ).toBe( [ "year", "author.name" ] );
                                return {};
                            } );

                            fractal.createData(
                                resource = resource,
                                excludes = "year,author.name"
                            ).convert();
                        } );

                        it( "makes the scoped excludes available in a component transformer", function() {
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

                            var bookTransformer = createMock( "tests.resources.BookTransformer" ).setManager( fractal );
                            bookTransformer.$( "transform", {} );
                            var authorTransformer = createMock( "tests.resources.AuthorTransformer" ).setManager( fractal );
                            authorTransformer.$( "transform", {} );
                            bookTransformer.$property( propertyName = "authorTransformer", mock = authorTransformer );
                            var resource = fractal.item( book, bookTransformer );
                            fractal.createData(
                                resource = resource,
                                includes = "author",
                                excludes = "year,author.name"
                            ).convert();

                            // Book Transformer
                            var callLog = bookTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 3, "At least three arguments should be passed to the transform function" );
                            var scopedExcludes = firstCall[ 3 ];
                            expect( scopedExcludes ).toBeArray();
                            expect( scopedExcludes ).toHaveLength( 1 );
                            expect( scopedExcludes ).toBe( [ "year" ] );

                            // Author Transformer
                            var callLog = authorTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 3, "At least three arguments should be passed to the transform function" );
                            var scopedExcludes = firstCall[ 3 ];
                            expect( scopedExcludes ).toBeArray();
                            expect( scopedExcludes ).toHaveLength( 1 );
                            expect( scopedExcludes ).toBe( [ "name" ] );
                        } );

                        it( "makes the full excludes available in a component transformer", function() {
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

                            var bookTransformer = createMock( "tests.resources.BookTransformer" ).setManager( fractal );
                            bookTransformer.$( "transform", {} );
                            var authorTransformer = createMock( "tests.resources.AuthorTransformer" ).setManager( fractal );
                            authorTransformer.$( "transform", {} );
                            bookTransformer.$property( propertyName = "authorTransformer", mock = authorTransformer );
                            var resource = fractal.item( book, bookTransformer );
                            fractal.createData(
                                resource = resource,
                                includes = "author",
                                excludes = "year,author.name"
                            ).convert();

                            // Book Transformer
                            var callLog = bookTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 5, "At least five arguments should be passed to the transform function" );
                            var allIncludes = firstCall[ 5 ];
                            expect( allIncludes ).toBeArray();
                            expect( allIncludes ).toHaveLength( 2 );
                            expect( allIncludes ).toBe( [ "year", "author.name" ] );

                            // Author Transformer
                            var callLog = authorTransformer.$callLog();
                            expect( callLog ).toBeStruct();
                            expect( callLog ).toHaveKey( "transform" );
                            var transformCallLog = callLog.transform;
                            expect( transformCallLog ).toBeArray();
                            expect( transformCallLog ).toHaveLength( 1 );
                            var firstCall = transformCallLog[ 1 ];
                            expect( arrayLen( firstCall ) ).toBeGTE( 5, "At least five arguments should be passed to the transform function" );
                            var allIncludes = firstCall[ 5 ];
                            expect( allIncludes ).toBeArray();
                            expect( allIncludes ).toHaveLength( 2 );
                            expect( allIncludes ).toBe( [ "year", "author.name" ] );
                        } );
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
                        var resource = fractal.collection( books, function( book ) {
                            return {
                                "id" = book.getId(),
                                "title" = book.getTitle(),
                                "year" = book.getYear()
                            };
                        } );

                        var scope = fractal.createData( resource );
                        expect( scope.convert() ).toBe( {"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]} );
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

                        var resource = fractal.collection( books, new tests.resources.BookTransformer().setManager( fractal ) );

                        var scope = fractal.createData( resource );
                        expect( scope.convert() ).toBe( {"data":[{"year":1960,"title":"To Kill a Mockingbird","id":1},{"year":1859,"title":"A Tale of Two Cities","id":2}]} );
                    } );

                    describe( "pagination", function() {
                        it( "returns pagination data in a meta field", function() {
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

                            var resource = fractal.collection( books, new tests.resources.BookTransformer().setManager( fractal ) );
                            resource.setPagingData( { "maxrows" = 50, "page" = 2, "pages" = 3, "totalRecords" = 112 } );

                            var scope = fractal.createData( resource );
                            expect( scope.convert() ).toBe( {
                                "data": [
                                    {
                                        "id": 1,
                                        "title": "To Kill a Mockingbird",
                                        "year": 1960
                                    },
                                    {
                                        "id": 2,
                                        "title": "A Tale of Two Cities",
                                        "year": 1859
                                    }
                                ],
                                "meta": {
                                    "pagination": {
                                        "maxrows": 50,
                                        "page": 2,
                                        "pages": 3,
                                        "totalRecords": 112
                                    }
                                }
                            } );
                        } );
                    } );
                } );
            } );
        } );
    }

}
