component accessors="true" extends="fractal.models.resources.AbstractResource" {
    
    function transform() {
        return transformData(
            getTransformer(),
            getData()
        );
    }

}