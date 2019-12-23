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
    readUMX(filename::String, directory=pwd())

Read the contents of a `*.umx` and return a `Matrix{Float64}`
"""
function readUMX(filename::String, directory = pwd())
    filename = prepare_path(filename, "umx", directory)
    result = Matrix{Float64}(undef, (0,0))

    open(filename, "r") do f
        skipStarting(f, ['#', '%'])
        result = readdlm(f, Float64, skipblanks = true)
    end

    return result
end
