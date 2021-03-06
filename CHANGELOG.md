# v8.1.1
## 13 Feb 2020 — 17:49:55 UTC

### other

+ __\*:__ chore: Use OpenJDK instead of OracleJDK ([8a6b8ca](https://github.com/coldbox-modules/cffractal/commit/8a6b8ca2fb61e6b31e85adea67379f5163ab9981))
+ __\*:__ chore: Use forgeboxStorage ([133118a](https://github.com/coldbox-modules/cffractal/commit/133118a6b37cc12ecf4ceab6e5fe4fc4fc71f48d))


# v8.1.0
## 28 May 2019 — 21:20:14 UTC

### feat

+ __XMLSerializer:__ Allow for a variable array separator in XML serialization other than <item> ([1c25b18](https://github.com/coldbox-modules/cffractal/commit/1c25b18da3c608b558dbc5af261a6747bc8be259))


# v8.0.1
## 21 Feb 2019 — 13:50:14 UTC

### fix

+ __AbstractResource:__ Ignore non-struct data when excluding keys ([a9d1e04](https://github.com/coldbox-modules/cffractal/commit/a9d1e04035d61f888d966368778bea197c15cee9))


# v8.0.0
## 14 Jan 2019 — 21:13:12 UTC

### BREAKING

+ __Scope:__ Fix for includes not respecting custom serializers ([06114f0](https://github.com/coldbox-modules/cffractal/commit/06114f02576e8fb9fd958057255585aac9dc3fd0))


# v7.0.1
## 04 Jan 2019 — 20:34:53 UTC

### fix

+ __ResultsMapSerializer:__ Add meta back to serializer output
 ([d9594d0](https://github.com/coldbox-modules/cffractal/commit/d9594d0789852f0878d1e85f22fc3c302c5a35e7))


# v7.0.0
## 22 Aug 2018 — 15:04:57 UTC

### BREAKING

+ __Excludes:__ Add ability to specify excludes ([d89fa06](https://github.com/coldbox-modules/cffractal/commit/d89fa063faaf7b8a5ef1c84bc90c936159006d10))

### chore

+ __ci:__ Replace flaky gpg key download with solid Ortus one
 ([754f451](https://github.com/coldbox-modules/cffractal/commit/754f451a44613819c7adc420c08965e3903d6117))

### feat

+ __Transformers:__ Pass includes and excludes inside a transformer ([03ac095](https://github.com/coldbox-modules/cffractal/commit/03ac09510a7dce8279c405f4b6093fb7511487f8))
+ __Transformers:__ Automatically remove unused available includes from the serialized output ([89f4938](https://github.com/coldbox-modules/cffractal/commit/89f4938efe7e5ffd4bf98d062c494dfec989e031))
+ __Transformers:__ Allow for Transformer-level item and collection serializers ([448a07d](https://github.com/coldbox-modules/cffractal/commit/448a07dcc5854c0106d142b6bd78903c28e60b95))
+ __Transformers:__ Add item callbacks when creating resources ([5e00c82](https://github.com/coldbox-modules/cffractal/commit/5e00c82360a98bb6ce7ca54b3d0a9b36c74483f1))
+ __Transfomers:__ Simple values can be returned from includes ([67c1507](https://github.com/coldbox-modules/cffractal/commit/67c15076833c040c9bfcd6331d5ca4513fd1fe95))

### fix

+ __Includes:__ Fix processing double includes
 ([ff33af5](https://github.com/coldbox-modules/cffractal/commit/ff33af5b23a7dd8786b49ea5e006ae762e48ada6))

### other

+ __\*:__ Temporarily remove emoji due to ForgeBox support
 ([9cc3e37](https://github.com/coldbox-modules/cffractal/commit/9cc3e37dc6df3be5d5507a3e6993d83298435576))


# Changelog

## 6.0.0

### Breaking Changes

+ Custom `Serializers` now need to implement two additional methods:
	+ `scopeData` — Decides how to nest the data under the given identifier. Most implementations will return the current data under the last identifier: `{ "#listLast( arguments.identifier, "." )#" = data };`
	+ `scopeRootKey` — Decides which key to use (if any) for the root of the serialized data.
+ Transformers can set a `resourceKey` property to be used if the transformer is the root transformer in certain serializers. (`variables.resourceKey = "book";`)  For instance, this property is used in the `XMLSerializer` to set the root node name.  If no `resourceKey` is set, or a callback transfomer is used, a default `resourceKey` of `data` will be used.
