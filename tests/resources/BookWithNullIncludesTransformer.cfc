component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.availableIncludes = [ "author" ];

    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getTitle(),
            "year" = book.getYear()
        };
    }

    function includeAuthor( book ) {
        return item(
            javacast( "null", "" ),
            new tests.resources.AuthorTransformer().setManager( manager )
        );
    }

}