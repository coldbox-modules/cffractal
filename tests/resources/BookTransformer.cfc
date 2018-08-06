component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.resourceKey = "book";
    variables.availableIncludes = [ "author", "isClassic" ];

    function init( sortKeys = true, authorTransformer = new tests.resources.AuthorTransformer() ) {
        variables.sortKeys = arguments.sortKeys;
        variables.authorTransformer = arguments.authorTransformer;
    }

    function transform( book ) {
        if ( sortKeys ) {
            return {
                "id" = book.getId(),
                "title" = book.getTitle(),
                "year" = book.getYear(),
                "isClassic" = book.getIsClassic()
            };
        }
        else {
            var hashMap = createObject( "java", "java.util.LinkedHashMap" ).init();
            hashMap[ "year" ] = "1960";
            hashMap[ "title" ] = "To Kill a Mockingbird";
            hashMap[ "id" ] = 1;
            hashMap[ "isClassic" ] = book.getIsClassic();
            return hashMap;
        }
    }

    function includeAuthor( book ) {
        return item(
            book.getAuthor(),
            variables.authorTransformer.setManager( manager )
        );
    }

    function includeIsClassic( book ) {
        return book.getIsClassic();
    }

}
