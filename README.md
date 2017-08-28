# cffractal

[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors)

[![Master Branch Build Status](https://img.shields.io/travis/coldbox-modules/cffractal/master.svg?style=flat-square&label=master)](https://travis-ci.org/coldbox-modules/cffractal)

## Transform business models to JSON data structures. Based on the [Fractal PHP library.](http://fractal.thephpleague.com/)

### Why CFFractal?

CFFractal in two sentences:

> Views take models and return HTML.
> CFFractal takes models and returns JSON (or your favorite serialized format).

You would want to use CFFractal if:

+ You need to transform your business models to json in many different places.
+ You need to include and exclude relationships depending on the endpoint.
+ You don't want to repeat yourself all over the place.

Take a look at some example code:

```js
// `books` can be anything from simple strings to structs to complex CFCs.

fractal.createData(
    resource = fractal.collection(
        data = books,
        transformer = getInstance( "BookTransformer" )
    ),
    includes = "author"
).convert();

// or

fractal.builder()
    .collection( books )
    .withTransformer( "BookTransformer" )
    .withIncludes( "author" )
    .convert();
```

Here's some more in-depth reasons:

1) Conventions around nested resources

CFFractal is able to parse your includes and excludes for you.  That means no more having to litter your transformers with `if` statements.  No more huge parameter lists.  Just one argument to pass: `includes`.  We'll handle the rest.

Also, includes are in the hands of the caller.  Does the caller not want the user?  Great.  Don't include it.  Do they want 6 levels of nested relationships?  Okay.  We'll do it.  Ultimate flexibility.

2) Default includes

Some includes are opt-in.  Others should always be included.  CFFractal makes this easy while still delegating transformation to each resource.

3) Nested includes

Do you want to get your post's author's comments?  No worries!  Your includes string can get that with `includes=author.comments`.  Have more levels?  Have at it!

4) Sharing resource transformations

Adding a field to an entity?  If you used CFFractal, you only need to add it to your transformer.  Every included resource will get it automatically.

You have a user entity that you want to serialize, but **not ever** with the password? Just exclude it in your `transform()` function.  All calls to CFFractal, including nested includes, will benefit from your attention to security for free.

5) Consistency

It is frustrating as a consumer of an API to have to make multiple requests where one should have sufficed.  One situation where this is sadly the case is inconsistent output between resources.  Does the `user` struct include the `last_logged_in` key when requesting from one endpoint but not another?  It is an easy mistake to make.  CFFractal helps to reduce these mistakes by creating a single source of truth for resource transformations — a `Transformer`.

Another place that is easy to mess up consistency is the response output.  Is your data nested in a `data` key?  Are you separating resources into their primary keys and a map?  It's too easy to have one endpoint behave differently than another.  In CFFractal, `Serializers` define the structure of the response and can help ensure a consistent output across your API endpoints.

6) Encapsulation

Playing with your model formats or your data layer code?  It won't affect your API if you used CFFractal.  Your `Transformers` are your single source of truth for model transformations.  If changes need to be made, they are encapsulated in those files.  Your API output will be unchanged from the consumer's point of view.

7) Flexible

From [Jon Clausen](https://twitter.com/jclausen):

> Having written API’s against MongoDB, ORM, and even a few that use legacy DAO/Gateway patterns, the benefit for me of the fractal transformation module is that I can use it for any of them, because of the transformer.  If the models already know how to accomplish the transformations to a degree, like our mementos in ORM, then that’s great.  
> 
> You don’t always have that, though, and you don’t always want a fully normalized expansion.  Sometimes you need only a small subset when dealing with secondary one-to-one relationships that need some normalization of the top level element.
> 
> This eliminates three methods that I always found myself writing (or copy/pasting and adapting) for every API handler:
> 
> 1.  The collection marshalling method
> 2.  The single entity response marshalling method
> 3.  The format entity method, which handles the expansion parameters in the collection

### Examples

#### Simple Example

```js
var fractal = new cffractal.models.Manager(
    itemSerializer = new cffractal.models.serializers.SimpleSerializer(),
    collectionSerializer = new cffractal.models.serializers.ResultsMapSerializer()
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

### API

#### Manager

The manager class is responsible for kicking off the transformation process.  This is generally the only class you need to inject in you handlers.  For convenience, this class is usually aliased as just `fractal`.

```js
property name="fractal" inject="Manager@cffractal";
```

There are three main functions to call off of fractal.  The first two are just factory functions: `item` and `collection`.  These help you create fractal resources from your models, specify transformers, and set a serializer override for items and collections.  (You can read all about those terms further down.)

> ##### `item`

> Creates a new item resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The data or model to serialize with fractal. |
> | transformer | AbstractTransformer or closure | true | | The class or closure that will transform the given data |
> | serializer | Serializer | false | The default item serializer for the Manager | The serializer for the transformed data.  If not provided, uses the default item serializer set for the Manager. |

> ##### `collection`

> Creates a new collection resource.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- |
> | data | any | true | | The data or model to serialize with fractal. |
> | transformer | AbstractTransformer or closure | true | | The class or closure that will transform the given data |
> | serializer | Serializer | false | The default collection serializer for the Manager | The serializer for the transformed data.  If not provided, uses the default collection serializer set for the Manager. |

Once you have a resource, you need to create the root scope.  Scopes in `cffractal` represent the nesting level of the resource.  Since resources can include sub-resources, we need a root scope to kick off the serializing process.  You do this through the `createData` method.

> ##### `createData`

> Creates a scope to serialize.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | resource | AbstractResource | true | | The fractal resource to serailize with fractal. |
> | includes | string | false | "" (empty string) | A list of includes identifiers for the serialization. |
> | identifier | string | false | "" (empty string) | The identifier for the current scope.  Defaults to "" (empty string), also know as the root scope. |

The return value is a Scope object.  To finish up the serialization process, we need to call `convert` or `toJSON` on this object.  But before we get to that, let's review the options that go in to the serialization process.

#### Serializers

A Serializer is responsible for the shape of the response, both the data and the metadata, additional information about the item or collection (such as pagination or links).

Perhaps you always want your data nested under a `data` key for consistency.  Maybe you want to separate the `results` as an array of ids from the `resultsMap` which is the data keyed by the id.  You might want a `metadata` key always present for any additional information, like pagination, that doesn't fit inside the normal data keys.  Whatever the shape, you can design a serializer that can produce it.

A serialzier needs two methods:

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

> ##### `getItemSerializer`

> Retrieves the current default item serializer.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |

> ##### `setItemSerializer`

> Sets a new default item serializer for the Manager.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | serializer | Serializer | true | | The new default item serializer for the Manager. |

> ##### `getCollectionSerializer`

> Retrieves the current default collection serializer.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |

> ##### `setCollectionSerializer`

> Sets a new default collection serializer for the Manager.

> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | serializer | Serializer | true | | The new default collection serializer for the Manager. |

Also, serializers can be overridden on individual resources.  The API for getting and setting serializers on resources is the same as it is for the Manager, but is just `getSerializer` and `setSerializer`, respectively.

```js
function includeNotes( task ) {
    return collection(
        data = task.getNotes(),
        transformer = function( note ) { return note; },
        serializer = wirebox.getInstance( "SimpleSerializer@cffractal" )
    );
}
```

There are three serializers included out of the box with `cffractal`:

#### `SimpleSerializer`

The `SimpleSerializer` returns the processed resource data directly and nests the metadata under a `meta` key.

```js
var model = {
    "foo" = "bar",
    "baz" = "qux"
};

// becomes

var transformed = {
    "foo" = "bar",
    "baz" = "qux",
    "meta" = {}
};
```

#### `DataSerializer`

The `DataSerializer` nests the processed resource data inside a `data` key and nests the metadata under a `meta` key.

```js
var model = {
    "foo" = "bar",
    "baz" = "qux"
};

// becomes

var transformed = {
    "data" = {
        "foo" = "bar",
        "baz" = "qux"
    },
    "meta" = {}
};
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

// becomes

var transformed = {
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
    "meta" = {}
};
```

#### Resources

Resources are a combination of your model, in whatever representation it may be in, and a transformer to take that data and normalize it for your API.  Resources come in two flavors, `item`s and `collection`s.  The API is identical for each.  The difference comes down to how the data is processed and if pagination is considered.

You can create a resource either from the `Manager` or from inside a `Transformer`.  The API is the same.

> #### API

> ##### `item`
>
> Creates a new `Item` resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The model to transform. |
> | transformer | any | true | | The transformer for the given model. |
> | serializer | Serializer | false | The default serializer on the Manager. | The serializer to use when serializing the data. |
 
> ##### `collection`
>
> Creates a new `Collection` resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The model to transform. |
> | transformer | any | true | | The transformer for the given model. |
> | serializer | Serializer | false | The default serializer on the Manager. | The serializer to use when serializing the data. |

##### Specifying Custom Serializers

As mentioned above, individual resources can have their serializer overridden.  This is useful if you only want one scope level to be serialized in a certain fashion (say, with the `DataSerializer`), and the rest to be serialized differently (say, with the `SimpleSerializer`).

You can retrieve and set the custom serializers right from the resource.

> ##### `getSerializer`
>
> Returns the current serializer for the resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |
 
> ##### `setSerializer`
>
> Sets the serializer for the resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | serializer | Serializer | true | | The serializer to associate with this specific resource. |

##### Metadata

CFFractal has a convention for metadata that allows the resource to add metadata items individually that are later combined through a serializer.  For instance, the `SimpleSerializer` adds all metadata fields directly on the transformed object.  The `DataSerializer` instead nests all of the metadata under a `meta` key. (See the serializer section for more details.)

You can add metadata directly on a resource instance.  The following metadata functions are available:

> ##### `addMeta`
>
> Adds some data under a given identifier in the metadata.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | key | string | true | | The key to nest the data under in the metadata scope. |
> | value | any | true | | The data to store under the given key. |
 
> ##### `hasMeta`
>
> Returns whether the resource has any metadata associated with it.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments. |

> ##### `getMeta`
>
> Returns the current metadata scope.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments. |

##### Post-Transformation Callbacks

A powerful feature of CFFractal is the ability to add post-transformation callbacks that will fire after transforming each item.  For an `item` resource, that means it will fire the callback once.  For a `collection` resource, the callback will be fired for each item in the collection.

Here's an example of a post-transformation function:

```js
// handlers/api/v1/books.cfc
component {

    this.API_BASE_URL = "/api/v1/books";

    function index( event, rc, prc ) {
        var books = fractal.collection(
            BookService.getAll(),
            function( book ) {
                return {
                    "id" = book.getId(),
                    "title" = book.getName(),
                    "yearPublished" = dateFormat( book.getPublishedDate(), "YYYY" )
                };
            }
        );
        
        books.addPostTransformationCallback( function( transformed, original, collection ) {
            transformed.href = this.API_BASE_URL & "/" & transformed.id;
            return transformed;
        } );

        var scope = fractal.createData( books );

        prc.response.setData(
            scope.convert();
        );
    }

}
```

Using a post-transformation callback, we are able to encapsulate data about the API version without coupling it to the transformer itself.  Sweet!

There are countless more usages here.  **The key thing to note is that the value returned from the callback becomes the new transformed item.**  The function API is as follows:

> ##### `addPostTransformationCallback`
>
> Add a post transformation callback to run after transforming each item.
> The value returned from the callback becomes the transformed item.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | callback | Callable | true | | A callback to run after the resource has been transformed. The callback will be passed the transformed data, the original data, and the resource object as arguments. |


##### Null Default Values

If the data of a resource is null or any item or include in the resource is null, CFFractal returns the Manager's `nullDefaultValue`.  This value can be set and retrieved from the Manager as follows:

> ##### `getNullDefaultValue`
>
> Returns the current null default value.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |
 
> ##### `setNullDefaultValue`
>
> Sets the null default value for the manager.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | nullDefaultValue | any | true | | The null default value for all resources. |

Additionally, this will be automatically configured for you in ColdBox to an empty string (`""`).  This can be overridden using the `nullDefaultValue` setting in your `config/ColdBox.cfc`:

```js
function configure() {
    moduleSettings = {
        cffractal = {
            nullDefaultValue = {}
        }
    };
}
```

#### Transformers

Transformers are like the view for your models.  It defines how to transform your model in to a serializable representation.

Transformers come in two flavors, closures and components.

##### Closure Transformers

Closure transformers are useful for simple transformations.  They are very convenient when you don't need any of the extra features of component transformers such as parsing includes and excludes because they are defined inline and very lightweight.

```js
fractal.item( book, function( book ) {
    return {
        "id" = book.getId(),
        "title" = book.getName(),
        "yearPublished" = book.getPublishedDate()
    };
} );
```

If you use a resource in more than one place or would like access to includes and excludes, you are going to want to use a component transformer.

##### Component Transformers

Component transformers are where the power of transformers lie and will likely be the main transformer type for your API.

Component transformers should be singleton objects that extend `cffractal.models.transformers.AbstractTransformer`.  Mark them as such in your DI container of choice.  With WireBox, it is as simple as appending the `singleton` component metadata attribute.

```js
component extends="cffractal.models.transformers.AbstractTransformer" singleton {
    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getName(),
            "yearPublished" = book.getPublishedDate()
        };
    }
}
```

You might be thinking that this is no better than a closure transformer.  The fact is, even in this state, we can now reuse this transformer without duplication!  For this reason alone, you can see why most of your transformers will be components.

Component transformers get even better when we talk about includes and excludes!

##### Includes

Includes are nested resources that can or should be included when serializing a resource.  Let's take our book example.

A book is written by an author and has a publisher.  The author, in turn, has a country they live in.

In our API endpoint, retrieving a book should always return information about the author.  It should optionally return information about the publisher as well as the author's country.

Let's set up all the models we've talked about.  (This will be our most comprehensive example yet.)

```js
component name="Book" accessors="true" {

    property name="id";
    property name="name";
    property name="publishedDate";

    property name="authorId";
    property name="publisherId";

    // we'll assume these methods do the right thing... 😉
    function getAuthor() { /* ... */ }
    function getPublisher() { /* ... */ }

}

component name="Author" accessors="true" {

    property name="id";
    property name="firstName";
    property name="lastName";

    property name="currentCountryId";

    // we'll assume these methods do the right thing... 😉
    function getCurrentCountry() { /* ... */ }

}

component name="Publisher" accessors="true" {

    property name="id";
    property name="name";

}

component name="Country" accessors="true" {

    property name="id";
    property name="name";
    property name="latitude";
    property name="longitude";

}
```

It doesn't matter how these models are populated or how they find their relations.  That's why the Transformer pattern is so powerful!  Let's set up our transformers now so we can see how includes work.

```js
component name="BookTransformer" extends="cffractal.models.transformers.AbstractTransformer" singleton {

    variables.defaultIncludes = [ "author" ];
    variables.availableIncludes = [ "publisher" ];

    function transform( book ) {
        return {
            "id" = book.getId(),
            "title" = book.getName(),
            "yearPublished" = dateFormat( book.getPublishedDate(), "YYYY" )
        };
    }

    function includeAuthor( book ) {
        return item(
            book.getAuthor(),
            wirebox.getInstance( "AuthorTransformer" )
        );
    }

    function includePublisher( book ) {
        return item(
            book.getPublisher(),
            wirebox.getInstance( "PublisherTransformer" )
        );
    }

}

component name="AuthorTransformer" extends="cffractal.models.transformers.AbstractTransformer" singleton {

    variables.availableIncludes = [ "country" ];

    function transform( author ) {
        return {
            "id" = author.getId(),
            "name" = author.getFirstName() & " " & author.getLastName();
        };
    }

    function includeCountry( author ) {
        return item(
            author.getCurrentCountry(),
            function( country ) {
                return {
                    "id" = country.getId(),
                    "name" = country.getName(),
                    "coordinate" = {
                        "latitude" = country.getLatitude(),
                        "longitude" = country.getLongitude()
                    }
                };
            }
        );
    }

}

component name="PublisherTransformer" extends="cffractal.models.transformers.AbstractTransformer" singleton {

    function transform( publisher ) {
        return {
            "id" = publisher.getId(),
            "name" = publisher.getName()
        };
    }

}
```

Whew.  That may seem like a lot of transformers to write, but remember that this is both insulating us from changes to our model layer while at the same time reducing future duplication.  We can now write our `authors` endpoint while reusing our existing `AuthorsTransformer`.  Neat!

On to includes.  There are two types of includes: `defaultIncludes` and `availableIncludes`.  Both of these arrays contain resource names.  During the transformation process, CFFractal will invoke a `include[Resource Name Here]` method on the transformer to retrieve the included data.

If you always want a related resource included, you want to specify it in your `defaultIncludes` array.  Why would you go to the trouble of specifying a resource in the `defaultIncludes` array as opposed to doing it inline? Because `defaultIncludes` reuse existing transformers to do their transformation and serialization.  We once again get to reuse our transformation layer with little additional effort.

If you want a resource to be available to include in your transformation if a caller desired, but not included by default, add it to your `availableIncludes` array.  This grants you the flexibility to define all the relationships and nested resources in the transformer while only loading them as needed.  How to include available includes will be seen in detail in the Scope section.

You might have noticed that there is no `CountryTransformer` component.  Rather, we opted for a closure component for the `Country` resource.  This probably isn't the right choice for our situation, but we opted for it here to show you that it is a possibility.  Including it here as a closure component would mean any logic for transforming a Country outside of the `AuthorTransformer` component would have to be duplicated.

In the end, we get a flexible API call.  If we set up our objects like this:

```js
var book = new Book( {
    id = 1,
    name = "To Kill A Mockingbird",
    publishedDate = createDate( 1960, 07, 11 ),
    authorId = 54,
    publisherId = 41
} );

var author = new Author( {
    id = 54,
    firstName = "Harper",
    lastName = "Lee",
    countryId = 50
} );

var publisher = new Publisher( {
    id = 41,
    name = "J. B. Lippincott & Co."
} );

var country = new Country( {
    id = 50,
    name = "United States of America"
    latitude = "38.895N",
    longitude = "77.037W"
} );

var resource = fractal.item(
    book,
    wirebox.getInstance( "BookTransformer" )
);
```

With just a base call to the `Manager`'s `createData` method:

```js
var transformedData = fractal.createData( resource ).toJSON();
```

We get the following response:

```json
{
    "data": {
        "id": 1,
        "title": "To Kill a Mockingbird",
        "yearPublished": "1960",
        "author": {
            "data": {
                "id": 54,
                "name": "Harper Lee"
            }
        }
    }
}
```

However, with the same resource but also adding in our includes:

```js
var transformedData = fractal.createData(
    resource = resource,
    includes = "author.country,publisher"
).toJSON();
```

We get a more in-depth response:

```json
{
    "data": {
        "id": 1,
        "title": "To Kill a Mockingbird",
        "yearPublished": "1960",
        "author": {
            "data": {
                "id": 54,
                "name": "Harper Lee",
                "country": {
                    "data": {
                        "id": 50,
                        "name": "United States of America",
                        "coordinates": {
                            "latitude": "38.895N",
                            "longitude": "77.037W"
                        }
                    }
                }
            }
        },
        "publisher": {
            "data": {
                "id": 41,
                "name": "J. B. Lippincott & Co."
            }
        }
    }
}
```

##### Excludes (coming soon)

#### Scope

Scope is the last piece of the CFFractal puzzle.  A `Scope` is a resource combined with any includes and a scope identifier. The scope identifier represents the current nesting level of the resource transformation.  A scope identifier of `""` (an empty string) represents the root level of the resource.  As includes are processed, additional scopes are created with the correctly scoped includes to continue the transformation and serialization processes.

This concept is especially important for nested includes.  In the example right before this section, there was an example of a nested include:

```js
var transformedData = fractal.createData(
    resource = resource,
    includes = "author.country"
).toJSON();
```

This is asking CFFractal to include the resource's author and that author's country.  In fact, `author` doesn't even need to be in the `defaultIncludes` array to be included in this case.  Included a nested resource will include all of it's parent resources as well.  (It does, however, at least need to be in the `availableIncludes` array to do anything.)

Let's step through this example to understand how it works.

1. The resource tries to resolve the `"author"` include.
2. It finds it on the `BookTransformer` and creates a new resource and embeds it in a new child scope where the scope identifier is `"author"`, the current include name. 
3. The includes are then evaluated against the current scope identifier.  While `"country"` is not a valid include from the root scope (`"book"`), in this child scope (`"author"`) `"country"` is a valid include.
4. `"country"` is processed under a further nested child scope with a scope identifier of `"country"`.
5. As this is the last step of the includes chain, each child scope is transformed, serialized, and then placed inside a key matching the scope identifier in its parent scope.

Scopes, while important, are mostly invisible in the CFFractal process.  The root scope is created by the initial call to `createData` and child scopes are created inside the transformation process for you.  Still, it is important to visualize the includes chain to help you when designing your transformers.

#### Builder

It is important to know the piece of CFFractal so you can use the full power of the library.  But it can seem a bit verbose.  To help alleviate this, CFFractal has a `Builder` class to help reduce boilerplate by leveraging conventions.  (You also might find that you just like the syntax better.)

The `Builder` component turns code like this:

```js
var fractal = new cffractal.models.Manager(
    itemSerializer = new cffractal.models.serializers.SimpleSerializer(),
    collectionSerializer = new cffractal.models.serializers.ResultsMapSerializer()
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

into code like this:

```js
var fractal = new cffractal.models.Manager(
    itemSerializer = new cffractal.models.serializers.SimpleSerializer(),
    collectionSerializer = new cffractal.models.serializers.ResultsMapSerializer()
);

var book = {
    id = 1,
    title = "To Kill A Mockingbird",
    author = "Harper Lee",
    author_birthyear = "1926"
};

var result = fractal.builder()
    .item( book )
    .withTransformer( "BookTransformer" )
    .withSerializer( "SimpleSerializer" )
    .withIncludes( "author" )
    .convert();

// {"data":{"id":1,"title":"To Kill A Mockingbird","author":{"name":"Harper Lee","year":"1926"},"links":{"uri":"/books/1"}}}
```

The `Builder` component uses the same API under the hood, but you may find the flow more to your sensibilities.  Additionally, the `withTransformer` and `withSerializer` methods will look up simple strings as WireBox mappings, streamlining your code even more.

The `Builder` has the following methods:

> #### API

> ##### `item`
>
> Sets the `Item` resource to be transformed.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The model to transform. |

> ##### `collection`
>
> Sets the `Collection` resource to be transformed.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | data | any | true | | The model to transform. |

> ##### `withTransformer`
>
> Sets the transformer to use. If the transformer is a simple value, the Builder will treat it as a WireBox binding.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | transformer | any | true | | The transformer to use. |

> ##### `withSerializer`
>
> Sets the serializer to use. If the serializer is a simple value, the Builder will treat it as a WireBox binding.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | serializer | any | true | | The serializer to use. |

> ##### `withIncludes`
>
> Sets the includes for the transformation.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | includes | any | true | | The includes for the transformation. |

> ##### `withMeta`
>
> Adds a key / value pair to the metadata for the resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | key | string | true | | The metadata key. |
> | value | any | true | | The metadata value. |

> ##### `withPagination`
>
> Sets the pagination metadata for the resource.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | pagination | any | true | | The pagination metadata. |

> ##### `withItemCallback`
>
> Add a callback to be called after each item is transformed.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | callback | Callable | true | | The callback to run after each item has been transformed. The callback will be passed the transformed data, the original data, and the resource object as arguments. |

> ##### `convert`
>
> Transforms the data using the set properties through the fractal manager.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |

> ##### `toJSON`
>
> Transform the data through cffractal and then serialize it to JSON.
>
> | Name | Type | Required | Default | Description |
> | --- | --- | --- | --- | --- | 
> | No arguments |

### Additional Resources

#### Have Questions?

Come find us on the [CFML Slack]() (#box-products channel) and ask us there.  We'd be happy to help!


## Contributors

Thanks goes to these wonderful people ([emoji key](https://github.com/kentcdodds/all-contributors#emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
| [<img src="https://avatars2.githubusercontent.com/u/2583646?v=3" width="100px;"/><br /><sub>Eric Peterson</sub>](https://github.com/elpete)<br />[💻](https://github.com/coldbox-modules/cffractal/commits?author=elpete "Code") [📖](https://github.com/coldbox-modules/cffractal/commits?author=elpete "Documentation") [💡](#example-elpete "Examples") [⚠️](https://github.com/coldbox-modules/cffractal/commits?author=elpete "Tests") | [<img src="https://avatars0.githubusercontent.com/u/5255645?v=3" width="100px;"/><br /><sub>Jon Clausen</sub>](http://silowebworks.com)<br />[🐛](https://github.com/coldbox-modules/cffractal/issues?q=author%3Ajclausen "Bug reports") [🎨](#design-jclausen "Design") [📖](https://github.com/coldbox-modules/cffractal/commits?author=jclausen "Documentation") |
| :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/kentcdodds/all-contributors) specification. Contributions of any kind welcome!
