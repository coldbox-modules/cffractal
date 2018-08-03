component extends="cffractal.models.transformers.AbstractTransformer" {

    function transform( planet ) {
        return {
            "id" = planet.getId(),
            "name" = planet.getName()
        };
    }

}
