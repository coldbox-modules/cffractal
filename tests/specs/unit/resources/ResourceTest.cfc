component extends="testbox.system.BaseSpec" {

    function run() {
        describe( "resource test", function() {
            it( "processing with a transformer and includes", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$property( propertyName = "excludes", mock = [] );
                var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                mockTransformer.$( "transform", { "foo" = "bar" } );
                mockTransformer.$( "hasIncludes", true );
                mockTransformer.$( "processIncludes" ).$args( mockScope, { "foo" = "bar" } ).$results( [ { "baz" = "bam" } ] );
                var item = new cffractal.models.resources.Item( { "foo" = "bar" }, mockTransformer, mockSerializer );

                var transformedData = item.process( mockScope );

                expect( transformedData ).toBe( { "foo" = "bar", "baz" = "bam" } );
            } );

            it( "can add any meta data to the resource", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                var item = new cffractal.models.resources.Item( { "foo" = "bar" }, mockTransformer, mockSerializer );
                item.addMeta( "foo", "bar" );
                item.addMeta( "baz", [ "a", "b", "c" ] );
                expect( item.getMeta() )
                    .toBe( { "foo" = "bar", "baz" = [ "a", "b", "c" ] } );
            } );

            it( "can specify a specific serializer", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$property( propertyName = "excludes", mock = [] );
                var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                mockTransformer.$( "transform", { "foo" = "bar" } );
                mockTransformer.$( "hasIncludes", true );
                mockTransformer.$( "processIncludes" ).$args( mockScope, { "foo" = "bar" } ).$results( [ { "baz" = "bam" } ] );
                var item = new cffractal.models.resources.Item( { "foo" = "bar" }, mockTransformer, mockSerializer );

                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.SimpleSerializer" );
                expect( item.getSerializer() ).toBeInstanceOf( "cffractal.models.serializers.DataSerializer" );
                item.setSerializer( mockSerializer );
                expect( item.getSerializer() ).toBeInstanceOf( "cffractal.models.serializers.SimpleSerializer" );
                var transformedData = item.process( mockScope );

                expect( transformedData ).toBe( { "foo" = "bar", "baz" = "bam" } );
            } );
        } );
    }

}
