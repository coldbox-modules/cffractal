component extends="fractal.models.AbstractTransformer" {

    variables.availableIncludes = [ "country" ];

    function transform( author ) {
        return {
            "name" = author.getName()
        };
    }

    function includeCountry( author ) {
        return item( author.getCountry(), function( country ) {
            return {
                "id" = country.getId(),
                "name" = country.getName()
            };
        } );
    }

}