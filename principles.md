# nectar design principles

*This is an experiment in making key package design principles explicit, versus* 
*only implicit in the code. The goal is to make maintenance easier, when spread*
*out over time and across people.* 
*(borrowed from https://github.com/r-lib/usethis/blob/main/principles.md)*

## naming

Function and argument names in this package reflect a tug-of-war between 
conventions used in [{httr2}](https://httr2.r-lib.org/) and conventions used in 
the [OpenAPI Specification](https://spec.openapis.org/oas/v3.1.0) (OAS). Use 
these rules to decide how to name things:

- Names should be `lower_snake_case`.
- Names should be unique. For example, {httr2} uses `path` in several functions 
  to refer to the URL path, but `req_cookie_preserve()` has a `path` argument 
  for an on-disk location. We use `file_path` for this second argument.
- Internal functions should begin with `.`. This is an older convention, but I 
  find it useful for keeping my mental model of the package clear. If an 
  unexported function is later exported, there will be work required to make 
  sure the function is renamed everywhere, and I consider this a feature, not a 
  bug; it makes it more likely that I'll catch strange circular references and 
  other sticking points.
- If a sub-function (internal) is necessary to keep code clean and readable, but 
  it doesn't do anything unique other than implementing the function that's 
  calling it, append `_impl` (implementation) to the end of the function name. 
  For example, `.req_path_append()` calls `.req_path_append_impl()` when a 
  `path` argument is provided.
- Lean toward the {httr2} conventions for names. If a function modifies a 
  request object, it should start with `req_`, and have an argument `req`. If a 
  function modifies a response object, it should start with `resp_`, and have an 
  argument `resp`. Exception: to keep documentation consistent, we use `resps` 
  for functions that accept lists of `resp` objects, even if they also accept 
  individual `resp` objects. In fact, all functions with `resps` arguments 
  should deal with the case where `resp` is an individual response object.
- If an argument name is confusing in {httr2}, it might be acceptable to rename 
  it. But be very careful about this. See above about unique names, though.
- Names should not overlap with {httr2} function names. A modified 
  `req_perform()` cannot be named `req_perform()`.
- If a function essentially translates from OAS to {httr2}, use OAS names for 
  arguments, and {httr2} names for the function. However...
- Arguments should be syntactic. Instead of `in` (used in 
  [OAS Security Scheme Objects](https://spec.openapis.org/oas/v3.1.0#security-scheme-object)), 
  use `location`.

## documentation

- All exported functions must be documented.
- Ideally, internal functions should also be documented, with 
  `@keywords internal`. They do not need a full description, but do include a 
  one-line description in the "Title" area, and document their parameters. Most 
  of the time, parameters will be documented in internal functions, and then 
  inherited in the calling exported function (see below). Exception: `_impl()` 
  functions do not need their own documentation; the parent function's 
  documentation covers the details in most or all cases. 
- Use `@inheritParams` liberally. Every parameter should be defined in exactly 
  one place. This makes it much easier to maintain definitions. If you add a new 
  parameter, globally search (ctrl-shift-F in RStudio) for `@param {name}` to 
  make sure it isn't already defined.
- If a parameter is reused but doesn't have a clear "home" (eg, `req` is used in 
  several unrelated functions), define it in the `.shared-params` block of 
  `aaa-shared.R`. It's ok to err on the side of definining things there.
- Likewise, if a return value is reused but doesn't have a clear "home" (eg the 
  `httr2::request` objects returned by several functions), define it once in 
  `aaa-shared.R` in a block with `@name .shared-{name}`, where `{name}` 
  concisely describes the return value. Use this in function documentation with
  `@inherit .shared-{name} return`.
- If a choice contradicts with the choice in {httr2}, explain and justify it in 
  documentation. Make sure it is extremely clear when a default is different.

## testing

TODO

## motivation

{nectar} is aimed at package writers who are wrapping APIs, particularly APIs 
with a clear OpenAPI specification. It is an intentionally opinionated 
framework, so it will make more assumptions than {httr2} about how you things
should work. Let's solve problems here once, and propogate those solutions out
to API-wrapping packages that use nectar. I think that means {nectar} will 
often have two paths through a function: one when things are set up just-so and
we can use information in the request or the class of an object to figure out 
precisely what to do, and then a fall-through for people who are using {nectar}
but haven't bought into the whole framework. The fall-through might fail in a 
lot of cases, but we should aim to make sure it works for the most common use
case(s). That said, probably start with the fall-through in most new areas, and 
then refine/perfect.
