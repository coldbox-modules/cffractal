component accessors="true" extends="fractal.models.AbstractResource" {
    
    function transform() {
        return transformData(
            getTransformer(),
            getData()
        );
    }

}