component extends="testbox.system.BaseSpec" {
    
    function run() {
        describe( "processing with a transformer and includes", function() {
            var mockScope = getMockBox().createMock( "fractal.models.Scope" );
            var mockTransformer = getMockBox().createMock( "fractal.models.AbstractTransformer" );
            mockTransformer.$( "transform", { "foo" = "bar" } );
            mockTransformer.$( "hasIncludes", true );
            mockTransformer.$( "processIncludes" ).$args( mockScope, { "foo" = "bar" } ).$results( [ { "baz" = "bam" } ] );
            var item = new fractal.models.resources.Item( { "foo" = "bar" }, mockTransformer );
            
            var transformedData = item.process( mockScope );

            expect( transformedData ).toBe( { "foo" = "bar", "baz" = "bam" } );
        } );
    }

}