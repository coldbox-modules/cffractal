component extends="testbox.system.BaseSpec" {

    variables.simpleItem = { "foo" = "bar" };

    function run() {
        describe( "item resources", function() {
            it( "can get the data from an item resource", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var item = new cffractal.models.resources.Item( simpleItem, function() {}, mockSerializer );
                prepareMock( item );
                expect( item.$getProperty( "data" ) ).toBe( simpleItem );
            } );

            it( "can add postTransformationCallbacks", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$property( propertyName = "excludes", mock = [] );
                mockScope.$( "getNullDefaultValue", {} );
                var item = new cffractal.models.resources.Item( {
                    "foo" = "bar"
                }, function( item ) {
                    return {
                        "foo" = item.foo & " " & item.foo
                    };
                }, mockSerializer );

                var callbackCalled = false;

                item.addPostTransformationCallback( function( itemStruct, itemInstance, resource ) {
                    expect( resource ).toBe( item );
                    expect( itemStruct.foo ).toBe( itemInstance.foo & " " & itemInstance.foo );
                    callbackCalled = true;
                    return itemStruct;
                } );

                item.process( mockScope );

                expect( callbackCalled ).toBeTrue( "Callback was never called" );
            } );

            it( "it processes nulls in postTransformationCallbacks correctly using the manager null default value", function() {
                var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                var mockScope = getMockBox().createMock( "cffractal.models.Scope" );
                mockScope.$( "getNullDefaultValue", {} );
                var item = new cffractal.models.resources.Item(
                    javacast( "null", "" ),
                    function( item ) {
                        return isNull( item ) ? javacast( "null", "" ) : item;
                    },
                    mockSerializer
                );

                var callbackCalled = false;

                item.addPostTransformationCallback( function( itemStruct, itemInstance ) {
                    callbackCalled = true;
                    return {};
                } );

                item.process( mockScope );

                expect( callbackCalled ).toBeTrue( "Callback was never called" );
            } );

            describe( "can get the transformer from an item resource", function() {
                it( "works with a closure", function() {
                    var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                    var item = new cffractal.models.resources.Item( simpleItem, function() {}, mockSerializer );
                    prepareMock( item );
                    expect( isClosure( item.$getProperty( "transformer" ) ) ).toBeTrue();
                } );

                it( "can work with components", function() {
                    var mockSerializer = getMockBox().createMock( "cffractal.models.serializers.DataSerializer" );
                    var transformerStub = getMockBox().createStub();
                    var item = new cffractal.models.resources.Item( simpleItem, transformerStub, mockSerializer );
                    prepareMock( item );
                    expect( item.$getProperty( "transformer" ) ).toBe( transformerStub );
                } );
            } );
        } );
    }

}
