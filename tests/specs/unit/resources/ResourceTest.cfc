component extends="testbox.system.BaseSpec" {
    
    function run() {
        describe( "resource test", function() {
            it( "processing with a transformer and includes", function() {
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                mockTransformer.$( "transform", { "foo" = "bar" } );
                mockTransformer.$( "hasIncludes", true );
                mockTransformer.$( "processIncludes" ).$args( mockScope, { "foo" = "bar" } ).$results( [ { "baz" = "bam" } ] );
                var item = new cffractal.models.resources.Item( { "foo" = "bar" }, mockTransformer );
                
                var transformedData = item.process( mockScope );

                expect( transformedData ).toBe( { "foo" = "bar", "baz" = "bam" } );
            } );

            it( "can add any meta data to the resource", function() {
                var mockTransformer = getMockBox().createMock( "cffractal.models.transformers.AbstractTransformer" );
                var item = new cffractal.models.resources.Item( { "foo" = "bar" }, mockTransformer );
                item.addMeta( "foo", "bar" );
                item.addMeta( "baz", [ "a", "b", "c" ] );
                expect( item.getMeta() )
                    .toBe( { "foo" = "bar", "baz" = [ "a", "b", "c" ] } );
            } );
        } );
    }

}