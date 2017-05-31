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

### Resources


### Serializers


### Transformers


#### Includes


#### Excludes (coming soon)