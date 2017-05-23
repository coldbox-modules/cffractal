component accessors="true" extends="fractal.models.resources.AbstractResource" {

    function transform() {
        var transformedData = [];
        for ( var value in getData() ) {
            arrayAppend(
                transformedData,
                transformData( getTransformer(), value )
            );
        }
        return transformedData;
    }

}