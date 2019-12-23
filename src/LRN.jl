# Copyright 2019 Tobias Frilling
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
    LRNCType

Enum representing the column types for LRNData:

`ignore = 0, data = 1, class = 3, key = 9`
"""
@enum LRNCType begin
    ignore = 0
    data = 1
    class = 3
    key = 9
end


"""
    LRNData

`LRNData` represents the contents of a `*.lrn` file.

# Fields
- `data::Matrix{Float64}`: Matrix of data, cases in rows, variables in columns.
- `column_types::Array{LRNCType, 1}`: Column types, see `LRNCType`.
- `key::Array{Integer, 1}`: Unique key for each line.
- `names::Array{String, 1}`: Column names.
- `key_name::String`: Name for key column.
- `comment::String`: Comments about the data.
"""
struct LRNData
    data::Matrix{Float64}
    column_types::Array{LRNCType,1}
    key::Array{Int64,1}
    names::Array{String,1}
    key_name::String
    comment::String

    function LRNData(data::Matrix{Float64}, column_types, key, names, key_name, comment)
        (nrow, ncol) = size(data)
        # Enforcing invariants
        @assert length(names) == ncol
        @assert length(key) == nrow
        @assert length(column_types) == ncol
        @assert allunique(key)
        @assert all(i -> 1 <= i <= nrow, key)
        new(data, column_types, key, names, key_name, comment)
    end
end


"""
    LRNData(data::AbstractMatrix{Float64})

Convenience constructor for `LRNData`. Uses sensible defaults:
```julia
column_types = [9,1,1...]
key          = [1,2,3...]
names        = ["C1","C2","C3"...]
key_name     = "Key"
comment      = ""
```
"""
function LRNData(
    data::AbstractMatrix{Float64};
    column_types = LRNCType.(fill(1, size(data, 2))),
    key          = collect(1:size(data, 1)),
    names        = fill("C", size(data, 2)) .* string.(1:size(data, 2)),
    key_name     = "Key",
    comment      = "",
)
    LRNData(data, column_types, key, names, key_name, comment)
end

Base.firstindex(D::LRNData) = 1
Base.lastindex(D::LRNData) = size(D, 2)
Base.getindex(D::LRNData, i::Int) = D.data[D.key[i], :]
Base.getindex(D::LRNData, I) = [D[i] for i in I]


"""
    writeLRN(filename::String, lrn::LRNData, directory=pwd())

Write the contents of a `LRNData` struct into a file.
"""
function writeLRN(lrn::LRNData, filename::String, directory = pwd())
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
            write(f, "$(lrn.key[index])\t$(join(new_row,'\t'))\n")
        end
    end
end


"""
    readLRN(filename::String, directory=pwd())

Read the contents of a `*.lrn` and return a `LRNData` struct.
"""
function readLRN(filename::String, directory = pwd())
    data = []
    column_types = []
    key = []
    names = []
    key_name = ""
    comment = ""
    key_index = 0

    # There is currently no way to have a native file chooser dialogue
    # without building a whole Gtk/Tk GUI

    filename = prepare_path(filename, "lrn", directory)
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
        column_types = map(x -> LRNCType(parse(Int, x)), column_types)
        key_index = findfirst(x -> x == DataIO.key, column_types)
        deleteat!(column_types, key_index)
        line = readline(f)
        # Names
        names = split(strip_header(line), '\t')
        key_name = names[key_index]
        deleteat!(names, key_index)
        # Data
        data = readdlm(f, Float64, skipblanks = true)
        key = map(Int, data[:, key_index])
        data = data[:, deleteat!(collect(1:ncol), key_index)] # remove key column
    end

    LRNData(data, column_types, key, names, key_name, comment)
end
