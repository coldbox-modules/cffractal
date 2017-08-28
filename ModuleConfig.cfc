component {

    this.name = "cffractal";
    this.author = "Eric Peterson";
    this.autoMapModels = false;
    this.cfmapping = "cffractal";
    this.webUrl = "https://github.com/elpete/cffractal";

    function configure() {
        settings = {
            defaultItemSerializer = "SimpleSerializer",
            defaultCollectionSerializer = "ResultsMapSerializer",
            nullDefaultValue = {}
        };
    }

    function onLoad() {
        binder.map( "SimpleSerializer@cffractal" ).asSingleton()
            .to( "#moduleMapping#.models.serializers.SimpleSerializer" );
        binder.map( "DataSerializer@cffractal" ).asSingleton()
            .to( "#moduleMapping#.models.serializers.DataSerializer" );
        binder.map( "ResultsMapSerializer@cffractal" ).asSingleton()
            .to( "#moduleMapping#.models.serializers.ResultsMapSerializer" );

        binder.map( "Manager@cffractal" )
            .to( "#moduleMapping#.models.Manager" )
            .asSingleton()
            .initArg(
                name = "itemSerializer",
                ref = "#moduleMapping#.models.serializers.#settings.defaultItemSerializer#"
            )
            .initArg(
                name = "collectionSerializer",
                ref = "#moduleMapping#.models.serializers.#settings.defaultCollectionSerializer#"
            )
            .initArg(
                name = "nullDefaultValue",
                value = settings.nullDefaultValue
            );

        binder.map( "Builder@cffractal" )
            .to( "#moduleMapping#.models.Builder" );
    }
}
