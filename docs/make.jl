push!(LOAD_PATH,"../src/")

using Documenter
using DataIO

makedocs(
    sitename = "DataIO.jl",
    authors = "Tobias Frilling",
    format = Documenter.HTML(),
    modules = [DataIO],
    pages = [
        "Home" => "index.md",
        "File Formats" => [
            "Data (*.lrn)" => "lrn.md"
        ]
    ]
)

deploydocs(
    repo = "github.com/ckafi/DataIO.jl"
)
