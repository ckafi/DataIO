var documenterSearchIndex = {"docs":
[{"location":"lrn/#LRN-1","page":"Data (*.lrn)","title":"LRN","text":"","category":"section"},{"location":"lrn/#File-structure-1","page":"Data (*.lrn)","title":"File structure","text":"","category":"section"},{"location":"lrn/#","page":"Data (*.lrn)","title":"Data (*.lrn)","text":"The *.lrn file contains the input data as tab separated values. Features in columns, datasets in rows. The first column should be a unique integer key. The optional header contains descriptions of the columns.","category":"page"},{"location":"lrn/#","page":"Data (*.lrn)","title":"Data (*.lrn)","text":"# comment\n#\n% n\n% m\n% s1          s2          ..      sm\n% var_name1   var_name2   ..      var_namem\nx11           x12         ..      x1m\nx21           x22         ..      x2m\n.             .           .       .\n.             .           .       .\nxn1           xn2         ..      xnm","category":"page"},{"location":"lrn/#","page":"Data (*.lrn)","title":"Data (*.lrn)","text":"Element Description\nn Number of datasets\nm Number of columns (including index)\ns_i Type of column: 9 for unique key, 1 for data, 0 to ignore column\nvar_name_i Name for the i-th feature\nx_ij Elements of the data matrix. Decimal numbers denoted by '.', not by ','","category":"page"},{"location":"lrn/#Writing-and-Reading-1","page":"Data (*.lrn)","title":"Writing and Reading","text":"","category":"section"},{"location":"lrn/#","page":"Data (*.lrn)","title":"Data (*.lrn)","text":"writeLRN\nreadLRN","category":"page"},{"location":"lrn/#DataIo.writeLRN","page":"Data (*.lrn)","title":"DataIo.writeLRN","text":"writeLRN(filename::String, lrn::LRNData, directory=pwd())\n\nWrite the contents of a LRNData struct into a file.\n\n\n\n\n\n","category":"function"},{"location":"lrn/#DataIo.readLRN","page":"Data (*.lrn)","title":"DataIo.readLRN","text":"readLRN(filename::String, directory=pwd())\n\nRead the contents of a *.lrn and return a LRNData struct.\n\n\n\n\n\n","category":"function"},{"location":"lrn/#Types-and-Constructors-1","page":"Data (*.lrn)","title":"Types and Constructors","text":"","category":"section"},{"location":"lrn/#","page":"Data (*.lrn)","title":"Data (*.lrn)","text":"LRNData\nLRNData(::AbstractMatrix{Float64})\nLRNCType","category":"page"},{"location":"lrn/#DataIo.LRNData","page":"Data (*.lrn)","title":"DataIo.LRNData","text":"LRNData\n\nLRNData represents the contents of a *.lrn file with the following fields:\n\ndata::Matrix{Float64}\nMatrix of data, cases in rows, variables in columns\ncolumn_types::Array{LRNCType, 1}\nColumn types, see LRNCType\nkey::Array{Integer, 1}\nUnique key for each line\nnames::Array{String, 1}\nColumn names\nkey_name::String\nName for key column\ncomment::String\nComments about the data\n\n\n\n\n\n","category":"type"},{"location":"lrn/#DataIo.LRNData-Tuple{AbstractArray{Float64,2}}","page":"Data (*.lrn)","title":"DataIo.LRNData","text":"LRNData(data::AbstractMatrix{Float64})\n\nConvenience constructor for LRNData. Uses sensible defaults:\n\ncolumn_types=[9,1,1...]\nkey=[1,2,3...]\nnames=[\"C1\",\"C2\",\"C3\"...]\nkey_name=\"Key\"\ncomment=\"\"\n\n\n\n\n\n","category":"method"},{"location":"#DataIo.jl-1","page":"Home","title":"DataIo.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"A Julia port of the DataIO R package.","category":"page"},{"location":"#Introduction-1","page":"Home","title":"Introduction","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"This package provides functions for reading and writing of data files consisting of n  k  matrices.","category":"page"},{"location":"#Installation-1","page":"Home","title":"Installation","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"DataIo is not yet registered. To install the development version from a Julia REPL type ] to enter Pkg REPL mode and run","category":"page"},{"location":"#","page":"Home","title":"Home","text":"pkg> add https://github.com/ckafi/DataIo.jl","category":"page"}]
}
