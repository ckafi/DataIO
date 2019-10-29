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


function prepare_path(filename::String, extension::String, directory = pwd())::String
    # make sure the filename has the right extension
    filename = addext(filename, extension)
    # normalize path
    normpath(joinpath(directory, filename))
end