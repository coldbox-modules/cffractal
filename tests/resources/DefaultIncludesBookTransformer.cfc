component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.resourceKey = "book";
    variables.defaultIncludes = [ "author" ];

    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getTitle(),
            "year" = book.getYear()
        };
    }

    function includeAuthor( book ) {
        return item( book.getAuthor(), function( author ) {
            return {
                "name" = author.getName()
            };
        } );
    }

}
