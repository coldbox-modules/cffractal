# cffractal

[![Master Branch Build Status](https://img.shields.io/travis/elpete/cffractal/master.svg?style=flat-square&label=master)](https://travis-ci.org/elpete/cffractal)

## Transform business models to JSON data structures. Based on the [Fractal PHP library.](http://fractal.thephpleague.com/)

### Elevator Pitch

+ You need to transform your business models to json in many different places.
+ You need to include and exclude relationships depending on the endpoint.
+ You don't want to repeat yourself all over the place.

### Simple Example

```js
var fractal = new cffractal.models.Manager(
    new cffractal.models.serializers.DataSerializer()
);

var book = {
    id = 1,
    title = "To Kill A Mockingbird",
    author = "Harper Lee",
    author_birthyear = "1926"
};

var resource = fractal.item( book, function( book ) {
    return {
        id = book.id,
        title = book.title,
        author = {
            name = book.author,
            year = book.author_birthyear
        },
        links = {
            uri = "/books/" & books.id
        }
    };
} );

var transformedData = fractal.createData( resource ).toJSON();

// {"data":{"id":1,"title":"To Kill A Mockingbird","author":{"name":"Harper Lee","year":"1926"},"links":{"uri":"/books/1"}}}
```

### Manager

The manager class is responsible for kicking off the transformation process.  This is generally the only class you need to inject in you handlers.  For convenience, this class is usually aliased as just `fractal`.

```js
property name="fractal" inject="Manager@cffractal";
```

There are three main functions to call off of fractal.  The first two are just factory functions: `item` and `collection`.  These help you create fractal resources from your models, specify transformers, and set a serializer override.  (You can read all about those terms further down.)

> #### API

> ##### `item`

> Creates a new item resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The data or model to serailize with fractal. |
> | transformer | AbstractTransformer or closure | true | | The class or closure that will transform the given data |
> | serializer | Serializer | false | The default serializer for the Manager | The serializer for the transformed data.  If not provided, uses the default serializer set for the Manager. |

> ##### `collection`

> Creates a new collection resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- |
> | data | any | true | | The data or model to serailize with fractal. |
> | transformer | AbstractTransformer or closure | true | | The class or closure that will transform the given data |
> | serializer | Serializer | false | The default serializer for the Manager | The serializer for the transformed data.  If not provided, uses the default serializer set for the Manager. |

Once you have a resource, you need to create the root scope.  Scopes in `cffractal` represent the nesting level of the resource.  Since resources can include sub-resources, we need a root scope to kick off the serializing process.  You do this through the `createData` method.

> #### API

> ##### `createData`

> Creates a scope to serialize.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | resource | AbstractResource | true | | The fractal resource to serailize with fractal. |
> | includes | string | false | "" (empty string) | A list of includes identifiers for the serialization. |
> | identifier | string | false | "" (empty string) | The identifier for the current scope.  Defaults to "" (empty string), also know as the root scope. |

The return value is a Scope object.  To finish up the serialization process, we need to call `toStruct` or `toJSON` on this object.  But before we get to that, let's review the options that go in to the serialization process.

### Serializers

A serialzier needs two methods:

`data`

`meta`

### Resources

#### Items

#### Collections

#### Specifying Custom Serializers

### Transformers

#### Includes

#### Excludes (coming soon)

### Scope