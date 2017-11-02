# Changelog

## 6.0.0

### Breaking Changes

+ Custom `Serializers` now need to implement two additional methods:
	+ `scopeData` — Decides how to nest the data under the given identifier. Most implementations will return the current data under the last identifier: `{ "#listLast( arguments.identifier, "." )#" = data };`
	+ `scopeRootKey` — Decides which key to use (if any) for the root of the serialized data.
+ Transformers can set a `resourceKey` property to be used if the transformer is the root transformer in certain serializers. (`variables.resourceKey = "book";`)  For instance, this property is used in the `XMLSerializer` to set the root node name.  If no `resourceKey` is set, or a callback transfomer is used, a default `resourceKey` of `data` will be used.
