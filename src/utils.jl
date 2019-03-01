"""
    addext(filename::String, extension::String)

Add extension to filename if necessary.

# Examples
```jldoctest
julia> addext("hello", "data")
"hello.data"

julia> addext("hello.data", "data")
"hello.data"

julia> addext("hello.", ".data")
"hello.data"
```
"""
function addext(filename::String, extension::String)::String
    filename = rstrip(filename, '.')
    extension = extension[1] == '.' ? extension : '.' * extension
    endswith(filename, extension) ? filename : filename * extension
end


function prepare_path(filename::String, extension::String, directory=pwd())::String
    # make sure the filename has the right extension
    filename = addext(filename, extension)
    # normalize path
    normpath(joinpath(directory, filename))
end
