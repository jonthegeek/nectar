# nectar design principles

*This is an experiment in making key package design principles explicit, versus only implicit in the code. The goal is to make maintenance easier, when spread out over time and across people. (borrowed from https://github.com/r-lib/usethis/blob/main/principles.md)*

## naming

Function and argument names in this package reflect a tug-of-war between conventions used in [{httr2}](https://httr2.r-lib.org/) and conventions used in the [OpenAPI Specification](https://spec.openapis.org/oas/v3.1.0) (OAS). Use these rules to decide how to name things:

- Names should be `lower_snake_case`.
- Names should be unique. For example, {httr2} uses `path` in several functions to refer to the URL path, but `req_cookie_preserve()` has a `path` argument for an on-disk location. We use `file_path` for this second argument.
- Internal functions should begin with `.`. This is an older convention, but I find it useful for keeping my mental model of the package clear. If an unexported function is later exported, there will be work required to make sure the function is renamed everywhere, and I consider this a feature, not a bug; it makes it more likely to catch strange circular references and other sticking points.
- If a sub-function (internal) is necessary to keep code clean and readable, but it doesn't do anything unique other than implementing the function that's calling it, append `_impl` (implementation) to the end of the function name. For example, `.req_path_append()` calls `.req_path_append_impl()` when a `path` argument is provided.
- Lean toward the {httr2} conventions for names. If a function modifies a request object, it should start with `req_`, and have an argument `req`. If a function modifies a response object, it should start with `resp_`, and have an argument `resp`.
- If an argument name is confusing in {httr2}, it might be acceptable to rename it. But be very careful about this. See above about unique names, though.
- Names should not overlap with {httr2} function names. A modified `req_perform()` cannot be named `req_perform()`.
- If a function essentially translates from OAS to {httr2}, use OAS names for arguments, and {httr2} names for the function. However...
- Arguments should be syntactic. Instead of `in` (used in [OAS Security Scheme Objects](https://spec.openapis.org/oas/v3.1.0#security-scheme-object)), use `location`.

## documentation

- All exported functions must be documented.
- Ideally, internal functions should also be documented, with `@keywords internal`. They do not need a full description, but include a one-line description in the "Title" area, and document their parameters. Most of the time, parameters will be documented in internal functions, and then inherited in the calling exported function (see below). Exception: `_impl()` functions do not need their own documentation; the parent function's documentation covers the details in most or all cases. 
- Use `@inheritParams` liberally. Every parameter should be defined in exactly one place. This makes it much easier to maintain definitions. If you add a new parameter, globally search (ctrl-shift-F in RStudio) for `@param {name}` to make sure it isn't already defined.
- If a parameter is reused but doesn't have a clear "home" (eg, `req` is used in several unrelated functions), define it in the `.shared-parameters` block of `aaa-shared.R`.
- Likewise, if a return value is reused but doesn't have a clear "home" (eg the `httr2::request` objects returned by several functions), define it once in `aaa-shared.R` in a block with `@name .shared-{name}`, where `{name}` concisely describes the return value.
- If a choice contradicts with the choice in {httr2}, explain and justify it in documentation. Make sure it is extremely clear when a default is different.
