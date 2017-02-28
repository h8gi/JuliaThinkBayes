# Think Bayes by Julia
type Pmf
    dict::Dict
    Pmf(dict::Dict) = new(dict)
    function Pmf{T}(array::Array{T})
        pmf = new(zip(array, ones(length(array))) |> collect |> Dict)
        normalize!(pmf)
        pmf
    end
    Pmf(args...) = new(Dict(args...))
end

import Base.normalize
function normalize(pmf::Pmf)
    zip(keys(pmf.dict),
        normalize(collect(values(pmf.dict)), 1)) |> collect |> Pmf
end

function normalize!(pmf::Pmf)    
    pmf.dict = zip(keys(pmf.dict),
                   normalize(collect(values(pmf.dict)), 1)) |> collect |> Dict
end

prob(pmf::Pmf, key) = pmf.dict[key]

incr!(pmf::Pmf, key, step) = pmf.dict[key] += step
set!(pmf::Pmf, key, value) = pmf.dict[key] = value

mult(pmf::Pmf, key, ratio) = pmf.dict[key] * ratio
mult!(pmf::Pmf, key, ratio) = pmf.dict[key] *= ratio

abstract Suite

function update!(suite::Suite, data)
    for hypo in keys(suite.pmf.dict)
        like = likelihood(suite, data, hypo)
        mult!(suite.pmf, hypo, like)
    end
    normalize!(suite.pmf)
end


### cookie game
type Cookie <: Suite
    pmf::Pmf
    mixes::Dict
    function Cookie{T}(hypos::Array{T}, mixes::Dict)
        new(Pmf(hypos), mixes)
    end
end

function likelihood(cookie::Cookie, data, hypo)
    cookie.mixes[hypo][data]
end

cookie = Cookie(["Bowl 1", "Bowl 2"], Dict("Bowl 1" => Dict("vanilla" => 0.75,
                                                            "chocolate" => 0.25),
                                           "Bowl 2" => Dict("vanilla" => 0.5,
                                                            "chocolate" => 0.5)))
### Monty hall
type Monty <: Suite
    pmf::Pmf
    function Monty{T}(hypos::Array{T})
        new(Pmf(hypos))
    end
end


function likelihood(monty::Monty, data, hypo)
    if hypo == data
        0
    elseif hypo == "A"
        0.5
    else
        1
    end
end

# monty = Monty(["A", "B", "C"])
