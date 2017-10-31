/**
* @name        SimpleSerializer
* @package     cffractal.models.serializers
* @description Does no further transformation to the data.
*/
component singleton {

    property name="rootName";

    function init( rootName = "root" ) {
        variables.rootName = arguments.rootName;
        return this;
    }

    /**
    * Does no further transformation to the data.
    *
    * @resource The resource to serialize.
    * @scope    A reference to the current Fractal scope.
    *
    * @returns  The processed resource, unnested.
    */
    function data( resource, scope ) {
        var xmlDoc = XMLNew();
        xmlDoc.xmlRoot = XMLElemNew( xmlDoc, variables.rootName );
        populateNode( xmlDoc.xmlRoot, resource.process( scope ), xmlDoc );
        return ToString( xmlDoc );
    }

    /**
    * Decides how to nest the data under the given identifier.
    *
    * @data       The serialized data.
    * @identifier The current identifier for the serialization process.
    *
    * @returns    The scoped, serialized data.
    */
    function scopeData( data, identifier ) {
        return { "#listLast( identifier, "." )#" = data };
    }

    /**
    * Decides which key to use (if any) for the root of the serialized data.
    *
    * @data       The serialized data.
    * @identifier The current identifier for the serialization process.
    *
    * @returns    The scoped, serialized data.
    */
    function scopeRootKey( data, identifier ) {
        var xmlDoc = XMLParse( data );
        var currentChildren = xmlDoc.xmlRoot.XmlChildren;
        var xmlData = XMLElemNew( xmlDoc, identifier );
        arrayAppend( xmlData.XmlChildren, currentChildren, true );
        arrayClear( xmlDoc.xmlRoot.XmlChildren );
        arrayAppend( xmlDoc.xmlRoot.XmlChildren, xmlData );
        return ToString( xmlDoc );
    }

    /**
    * Returns the metadata nested under a meta key.
    *
    * @data     The metadata for the response.
    *
    * @response The metadata nested under a "meta" key.
    */
    function meta( resource, scope, data ) {
        var xmlDoc = XMLParse( data );
        var metaNode = XMLElemNew( xmlDoc, "meta" );
        populateNode( metaNode, resource.getMeta(), xmlDoc );
        arrayAppend( xmlDoc.XmlRoot.XmlChildren, metaNode );
        return ToString( xmlDoc );
    }

    private function populateNode( parent, contents, root ) {
        if ( isArray( contents ) ) {
            arrayEach( contents, function( item ) {
                var newNode = XMLElemNew( root, "item" );
                populateNode( newNode, item, root );
                arrayAppend( parent.XmlChildren, newNode );
            } );
        }
        else if ( isStruct( contents ) ) {
            var keys = structKeyArray( contents );
            arraySort( keys, "textnocase" );
            arrayEach( keys, function( key ) {
                var newNode = XMLElemNew( root, key );
                populateNode( newNode, contents[ key ], root );
                arrayAppend( parent.XmlChildren, newNode );
            } );
        }
        else {
            parent.XmlText = contents;
        }
    }

}
