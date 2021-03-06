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

function addext(filename::String, extension::String)::String
    filename = rstrip(filename, '.')
    extension = extension[1] == '.' ? extension : '.' * extension
    endswith(filename, extension) ? filename : filename * extension
end


function prepare_path(filename::String, extension::String, directory = pwd())::String
    # make sure the filename has the right extension
    filename = addext(filename, extension)
    # normalize path
    normpath(joinpath(directory, filename))
end


function skipStarting(stream::IOStream, chars::AbstractVector{Char})
    c = read(stream, Char)
    while c in chars
        readline(stream)
        c = read(stream, Char)
    end
    skip(stream, -ncodeunits(c))
end



module RCompat

function r2j_weights(rweights::AbstractMatrix{Float64}, rows::Int, columns::Int)
    result = Array{Float64, 3}(undef, size(rweights)[2], rows, columns)
    for r in 1:rows, c in 1:columns
        ind = j2r_ind(r,c,columns)
        result[:,r,c] = rweights[ind,:]
    end
    result
end


function j2r_weights(jweights::AbstractArray{Float64, 3})
    (n, rows, columns) = size(jweights)
    result = Array{Float64, 2}(undef, rows*columns, n)
    for r in 1:rows, c in 1:columns
        ind = j2r_ind(r,c,columns)
        result[ind,:] = jweights[:,r,c]
    end
    result
end


@inline j2r_ind(_, r, c, columns) = j2r_ind(r, c, columns)


function j2r_ind(i::CartesianIndex, columns)
    j2r_ind(i.I...,columns)
end


function j2r_ind(r, c, columns)
    (r-1) * columns  + c
end


function r2j_ind(i, col)
    (div(i-1, col) + 1,
     mod(i-1, col) + 1)
end

end # module
