component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.resourceKey = "book";
    variables.defaultIncludes = [ "author", "bookCount" ];

    function init( withDefaultCountry = false ) {
        variables.withDefaultCountry = arguments.withDefaultCountry;
        return this;
    }

    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getTitle(),
            "year" = book.getYear()
        };
    }

    function includeAuthor( book ) {
        return item(
            book.getAuthor(),
            new tests.resources.DefaultIncludesAuthorTransformer( withDefaultCountry ).setManager( manager )
        );
    }

    function includeBookCount( book ) {
        return 4;
    }

}
