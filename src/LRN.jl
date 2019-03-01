include("utils.jl")

module LRN

import DelimitedFiles

export LRNCType, LRNData, writeLRN, readLRN


"""
    LRNCType

Enum representing the column types for LRNData:

ignore = 0, data = 1, class = 3
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
- `data::Matrix{Float64}`

  Matrix of data, cases in rows, variables in columns

- `column_types::Array{LRNCType, 1}`

  Column types, see `LRNCType`

- `keys::Array{Integer, 1}`

  Unique key for each line

- `names::Array{String, 1}`

  Column names

- `key_name::String`

  Name for key column

- `comment::String`

  Comments about the data
"""
struct LRNData
    data::Matrix{Float64}
    column_types::Array{LRNCType, 1}
    keys::Array{Int64, 1}
    names::Array{String, 1}
    key_name::String
    comment::String

    function LRNData(data; column_types=[], keys=[], names=[], key_name="Key", comment="")
        (nrow, ncol) = size(data)
        if isempty(column_types)
            column_types = map(LRNCType, fill(1, ncol))
        end
        if isempty(keys)
            keys = 1:nrow
        end
        if isempty(names)
            names = map(*, fill("C",ncol), map(string,1:ncol))
        end
        # Enforcing invariants
        if length(names) != ncol
            throw(ArgumentError("Name count doesn't match number of columns"))
        end
        if length(keys) != nrow
            throw(ArgumentError("Number of keys doesn't match number of rows"))
        end
        if !allunique(keys)
            throw(ArgumentError("Keys must be unique"))
        end
        if length(column_types) != ncol
            throw(ArgumentError("Number of type specifiers doesn't match number of columns"))
        end
        if key in column_types
            throw(ArgumentError("Key vector must be provided seperatly."))
        end
        new(data, column_types, keys, names, key_name, comment)
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
        write(f, "% $(Int(key))\t$(join(map(Int,lrn.column_types), '\t'))\n")
        # write names
        write(f, "% $(lrn.key_name)\t$(join(lrn.names, '\t'))\n")
        # write data
        for (index, row) in enumerate(eachrow(lrn.data))
            new_row = replace(row, Inf => NaN)
            write(f, "$(lrn.keys[index])\t$(join(new_row,'\t'))\n")
        end
    end
end


"""
    readLRN(filename::String, directory=pwd())

Read the contents of a `*.lrn` and return a `LRNData` struct.
"""
function readLRN(filename::String, directory=pwd())
    data = []
    column_types = []
    keys = []
    names = []
    key_name = ""
    comment = ""
    key_index = 0

    # There is currently no way to have a native file chooser dialogue
    # without building a whole Gtk/Tk GUI
    filename = prepare_path(filename, "", directory)
    open(filename, "r") do f
        line = readline(f)
        # Comments
        while startswith(line, '#')
            comment *= strip(line, [' ', '\t', '#'])
            line = readline(f)
        end
        strip_header = l -> strip(l, [' ', '\t', '%'])
        # Number of datasets
        nrow = parse(Int, strip_header(line))
        line = readline(f)
        # Number of columns
        ncol = parse(Int, strip_header(line))
        line = readline(f)
        # Column types
        column_types = split(strip_header(line), '\t')
        println(column_types)
        column_types = map(x -> LRNCType(parse(Int,x)), column_types)
        key_index = findfirst(x -> x==key, column_types)
        deleteat!(column_types, key_index)
        line = readline(f)
        # Names
        names = split(strip_header(line), '\t')
        key_name = names[key_index]
        deleteat!(names, key_index)
        # Data
        data = DelimitedFiles.readdlm(f, '\t', Float64, skipblanks = true)
        keys = map(Int, data[:,key_index])
        data = data[:,deleteat!(collect(1:ncol), key_index)] # remove key column
    end

    LRNData(data, column_types, keys, names, key_name, comment)
end

end # module
