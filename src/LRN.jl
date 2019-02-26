include("utils.jl")

"""
    LRNCType

`LRNCType` represents the column types for LRNData:
ignore = 0, data = 1, class = 3
"""
@enum LRNCType begin
    ignore = 0
    data   = 1
    class  = 3
end

"""
    LRNData

`LRNData` represents the contents of a `*.lrn` file with the following fields:
- `data::AbstractMatrix{Float64}`

  Matrix of data, cases in rows, variables in columns

- `column_types::AbstractArray{LRNCType, 1}`

  Column types, see `LRNCType`

- `keys::AbstractArray{Integer, 1}`

  Unique key for each line

- `header::AbstractArray{AbstractString, 1}`

  Column names

- `key_header::AbstractString`

  Header for key column

- `comment::AbstractString`

  Comments about the data
"""
mutable struct LRNData
    data::AbstractMatrix{Float64}
    column_types::AbstractArray{LRNCType, 1}
    keys::AbstractArray{Integer, 1}
    header::AbstractArray{AbstractString, 1}
    key_header::AbstractString
    comment::AbstractString

    function LRNData(data, column_types=[], keys=[], header=[], key_header="Key", comment="")
        (nrow, ncol) = size(data)
        if isempty(column_types)
            column_types = map(LRNCType, fill(1, ncol))
        end
        if isempty(keys)
            keys = 1:nrow
        end
        if isempty(header)
            header = map(*, fill("C",ncol), map(string,1:ncol))
        end
        # Enforcing invariants
        if length(header) != ncol
            throw(ArgumentError("Header size doesn't match number of columns"))
        end
        if length(keys) != nrow
            throw(ArgumentError("Number of keys doesn't match number of rows"))
        end
        if length(column_types) != ncol
            throw(ArgumentError("Number of type specifiers doesn't match number of columns"))
        end
        if !allunique(keys)
            throw(ArgumentError("Keys must be unique"))
        end
        new(data, column_types, keys, header, key_header, comment)
    end
end

"""
    writeLRN(filename::String, lrn::LRNData, directory=pwd())

Write the contents of a `LRNData` struct into a file.
"""
function writeLRN(lrn::LRNData, filename::String, directory=pwd())
    (nrow, ncol) = size(lrn.data)
    filename = prepare_path(filename, "lrn", directory)
    open(filename, "w") do f
        # write comment if it exists
        if !isempty(lrn.comment)
            write(f, "# $(lrn.comment)\n#\n")
        end
        # write number of cases
        write(f, "% $(nrow)\n")
        # write number of variables (+1 for key)
        write(f, "% $(ncol+1)\n")
        # write column types (9 for key)
        write(f, "% 9\t$(join(map(Int,lrn.column_types), '\t'))\n")
        # write header
        write(f, "% $(lrn.key_header)\t$(join(lrn.header, '\t'))\n")
        # write data
        for (index, row) in enumerate(eachrow(lrn.data))
            new_row = replace(row, Inf => NaN)
            write(f, "$(lrn.keys[index])\t$(join(new_row,'\t'))\n")
        end
    end
end
