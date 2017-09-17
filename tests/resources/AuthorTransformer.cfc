component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.availableIncludes = [ "country" ];

    function transform( author ) {
        return {
            "name" = author.getName()
        };
    }

    function includeCountry( author ) {
        return item( author.getCountry(), new tests.resources.CountryTransformer( manager ) );
    }

}
