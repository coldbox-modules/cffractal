component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.availableIncludes = [ "country", "books" ];

    function transform( author ) {
        return {
            "name" = author.getName()
        };
    }

    function includeBooks( author ) {
        return collection(
            author.getBooks(),
            new tests.resources.BookTransformer().setManager( manager ),
            new cffractal.models.serializers.ResultsMapSerializer()
        );
    }

    function includeCountry( author ) {
        return item( author.getCountry(), new tests.resources.CountryTransformer().setManager( manager ) );
    }

}
