component {
    
    this.name = "cffractal";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cffractal";

    function configure() {
        settings = {
            defaultSerializer = "DataSerializer"
        };
    }

    function onLoad() {
        binder.map( "Manager@cffractal" )
            .to( "fractal.models.Manager" )
            .initArg(
                name = "serializer",
                ref = "#settings.defaultSerializer#@cffractal"
            );
    }
}