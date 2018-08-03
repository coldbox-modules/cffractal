component extends="cffractal.models.transformers.AbstractTransformer" {

    function init( withDefaultCountry = false ) {
        if ( withDefaultCountry ) {
            variables.defaultIncludes = [ "country" ];
        }
        else {
            variables.availableIncludes = [ "country" ];
        }
    }

    function transform( author ) {
        return {
            "name" = author.getName()
        };
    }

    function includeCountry( author ) {
        return item( author.getCountry(), new tests.resources.CountryTransformer().setManager( manager ) );
    }

}
