"""
    addext(filename::String, extension::String)

Add extension to filename if necessary.

# Examples
```jldoctest
julia> addext("hello", "data")
"hello.data"

julia> addext("hello.data", "data")
"hello.data"
```
"""
function addext(filename::String, extension::String)::String
    endswith(filename, extension) ? filename : filename*"."*extension
end
