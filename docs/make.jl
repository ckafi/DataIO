push!(LOAD_PATH,"../src/")

using Documenter
using DataIO

makedocs(
    sitename = "DataIO",
    format = Documenter.HTML(),
    modules = [DataIO]
)

deploydocs(
   repo = "github.com/ckafi/DataIO"
)
