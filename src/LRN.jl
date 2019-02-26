include("addext.jl")
"""
    LRNCType

`LRNCType` represents the column types for LRNData:
ignore = 0, data = 1, class = 3, key = 9
"""
@enum LRNCType begin
    ignore = 0
    data   = 1
    class  = 3
    key    = 9
end

"""
    LRNData

`LRNData` represents the contents of a `*.lrn` file with the following fields:
- `data::AbstractMatrix{T<:Real}`

  Matrix of data, cases in rows, variables in columns

- `header::AbstractArray{AbstractString, 1}`

  Column names

- `keys::AbstractArray{Integer, 1}`

  Unique key for each line

- `column_types::AbstractArray{Integer, 1}`

  Column types: 

- `comment::AbstractString`

  Comments about the data
"""
mutable struct LRNData{T<:Real}
    data::AbstractMatrix{T}
    header::AbstractArray{AbstractString, 1}
    keys::AbstractArray{Integer, 1}
    column_types::AbstractArray{LRNCType, 1}
    comment::AbstractString

    # Enforcing invariants
    function LRNData{T}(data, header, keys, column_types, comment) where T<:Real
        (nrow, ncol) = size(data)
        if length(header) != (ncol+1)
            throw(ArgumentError("Header size doesn't match number of columns"))
        end
        if length(keys) != nrow
            throw(ArgumentError("Number of keys doesn't match number of rows"))
        end
        if length(column_types) != (ncol+1)
            throw(ArgumentError("Number of type specifiers doesn't match number of columns"))
        end
        if !allunique(keys)
            throw(ArgumentError("Keys must be unique"))
        end
        new{T}(data, header, keys, column_types, comment)
    end
end

"""
    writeLRN(filename::String, lrn::LRNData, directory=pwd())

Write the contents of a `LRNData` struct into a file.
"""
function writeLRN(filename::String, lrn::LRNData, directory=pwd())
    (nrow, ncol) = size(lrn.data)
    # make sure the filename has the right extension
    filename = addext(filename, "lrn")
    # normalize path
    normpath(joinpath(directory, filename))
    open(filename, "w") do f
        # write comment if it exists
        if !isempty(lrn.comment)
            write(f, "# $(lrn.comment)\n#\n")
        end
        # write number of cases
        write(f, "% $(nrow)\n")
        # write number of variables (+1 for key)
        write(f, "% $(ncol+1)\n")
        # write column types
        write(f, "% $(join(map(Int,lrn.column_types), '\t'))\n")
        # write header
        write(f, "% $(join(lrn.header, '\t'))\n")
        # write data
        for (index, row) in enumerate(eachrow(lrn.data))
            write(f, "$(lrn.keys[index])\t$(join(row,'\t'))\n")
        end
    end
end
