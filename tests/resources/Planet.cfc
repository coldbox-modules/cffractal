component accessors="true" {

    property name="id";
    property name="name";

    function init( struct args = {} ) {
        for ( var arg in args ) {
            if ( structKeyExists( variables, "set#arg#" ) || structKeyExists( this, "set#arg#" ) ) {
                invoke( this, "set#arg#", { 1 = args[ arg ] } );
            }
        }
        return this;
    }

}
