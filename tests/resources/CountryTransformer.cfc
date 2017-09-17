component extends="cffractal.models.transformers.AbstractTransformer" {

    variables.availableIncludes = [ "planet" ];

    function transform( country ) {
        return {
            "id" = country.getId(),
            "name" = country.getName()
        };
    }

    function includePlanet( country ) {
        return item( country.getPlanet(), function( planet ) {
            return {
                "id" = planet.getId(),
                "name" = planet.getName()
            };
        } );
    }

}
