component accessors="true" {

    property name="manager";
    property name="resource";

    function init( manager, resource ) {
        setManager( manager );
        setResource( resource );
        return this;
    }

    function toStruct() {
        return getManager().serialize(
            getResource().transform()
        );
    }

    function toJSON() {        
        return serializeJSON( toStruct() );
    }

    function transformData( transformer, data ) {
        return isClosure( transformer ) ?
            transformer( data ) :
            transformer.transform( data );
    }

}