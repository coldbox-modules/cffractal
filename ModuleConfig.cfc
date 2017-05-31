component {
    
    this.name = "cffractal";
    this.author = "Eric Peterson";
    this.autoMapModels = false;
    this.webUrl = "https://github.com/elpete/cffractal";

    function configure() {
        settings = {
            defaultSerializer = "DataSerializer"
        };
    }

    function onLoad() {
        binder.map( "Manager@cffractal" )
            .to( "#moduleMapping#.models.Manager" )
            .asSingleton()
            .initArg(
                name = "serializer",
                ref = "#moduleMapping#.models.serializers.#settings.defaultSerializer#"
            );
    }
}