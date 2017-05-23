component accessors="true" {

    property name="defaultIncludes";
    property name="availableIncludes";

    function transform() {
        throw(
            type = "MethodNotImplemented",
            message = "The method `transform()` must be implemented in a subclass."
        );
    }

    function item( data, transformer ) {
        return new fractal.models.resources.Item( data, transformer );
    }

    function collection( data, transformer ) {
        return new fractal.models.resources.Collection( data, transformer );
    }
}