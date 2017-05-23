component accessors="true" {

    property name="serializer";

    function init( serializer ) {
        setSerializer( serializer );
        return this;
    }

    function createData( resource ) {
        return new fractal.models.Scope( this, resource );
    }

    function serialize( data ) {
        return getSerializer().serialize( data );
    }

}