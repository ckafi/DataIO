push!(LOAD_PATH,"../src/")

using Documenter
using DataIo

makedocs(
    sitename = "DataIo.jl",
    authors = "Tobias Frilling",
    format = Documenter.HTML(),
    modules = [DataIo],
    pages = [
        "Home" => "index.md",
        "File Formats" => [
            "Data `(*.lrn)`" => "lrn.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/ckafi/DataIo.jl"
)
