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

> #### API

> ##### `data`

> Serializes the data portion of a resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | resource | AbstractResource | true | | The fractal resource to process and serailize. |
> | scope | Scope | true | | The current scope instance.  Included to pass along to the resource during processing. |


> ##### `meta`

> Serializes the metadata portion of a resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | resource | AbstractResource | true | | The fractal resource to process and serailize. |
> | scope | Scope | true | | The current scope instance.  Included to pass along to the resource during processing. |

A default serializer is configured for the application when creating the Fractal manager.  Unless overridden, this is the serializer used for each scope in the serialization processes.

The current serializer for the Manager can be retrieved at any time by calling `getSerializer`.  Additionally, a new default serializer can be set on the Manager by calling `setSerializer`.

> #### API

> ##### `getSerializer`

> Retrieves the current default serializer.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |

> ##### `setSerializer`

> Sets a new default serializer for the Manager.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | serializer | Serializer | true | | The new default serializer for the Manager. |

Also, serializers can be overridden on individual resources.  The API for getting and setting serializers on resources is the same as it is for the Manager.

There are three serializers included out of the box with `cffractal`:

#### `SimpleSerializer`

The `SimpleSerializer` returns the processed resource data directly and nests the metadata under a `meta` key.

```js
var model = {
    "foo" = "bar",
    "baz" = "qux"
};

var result = SimpleSerializer.data( model );

/*
{
    "foo" = "bar",
    "baz" = "qux",
    "meta" = {
        "link" = "/api/v1/foo"    
    }
}
*/
```

#### `DataSerializer`

The `DataSerializer` nests the processed resource data inside a `data` key and nests the metadata under a `meta` key.

```js
var model = {
    "foo" = "bar",
    "baz" = "qux"
};

var result = DataSerializer.data( model );

/*
{
    "data" = {
        "foo" = "bar",
        "baz" = "qux"
    },
    "meta" = {
        "link" = "/api/v1/foo"    
    }
}
*/
```

#### `ResultsMapSerializer`

The `ResultsMapSerializer` nests the processed resource data inside a `resultsMap` struct keyed by an identifier column as well as an array of identifiers nested under a `results` key. The metadata is nested under a `meta` key.

If the processed resource is not an array, the data is returned unmodified.

The identifier column can be specified in the constructor.

> #### API

> ##### `init`

> Creates a new `ResultsMapSerializer`.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | identifier | string | false | "id" | The name of the primary key for the transformed data.  Used to key the results map and populate the results array. |

```js
var model = [
    { "id" = 1, "name" = "foo" },
    { "id" = 2, "name" = "bar" },
    { "id" = 3, "name" = "baz" },
    { "id" = 4, "name" = "qux" }
];

var result = ResultsMapSerializer.data( model );

/*
{
    "results" = [
        1,
        2,
        3,
        4
    ]
    "resultsMap" = {
        "1" = { "id" = 1, "name" = "foo" },
        "2" = { "id" = 2, "name" = "bar" },
        "3" = { "id" = 3, "name" = "baz" },
        "4" = { "id" = 4, "name" = "qux" }
    },
    "meta" = {
        "link" = "/api/v1/foo"    
    }
}
*/
```

### Resources

#### Items

#### Collections

#### Specifying Custom Serializers

As mentioned above, individual resources can have their serializer overridden.  This is useful if you only want one scope level to be serialized in a certain fashion (say, with the `DataSerializer`), and the rest to be serialized differently (say, with the `SimpleSerializer`).

### Transformers

#### Includes

#### Excludes (coming soon)

### Scope