#include("./thinkbayes.jl")
### Dice
type Dice <: Suite
    pmf::Pmf
    function Dice{T}(hypos::Array{T})
        new(Pmf(hypos))
    end
end

suite = Dice([4, 6, 8, 12, 20])

function likelihood(dice::Dice, data, hypo)
    if hypo < data
        0
    else
        1.0 / hypo
    end
end


update!(suite, 6)
for roll in [6, 8, 7, 7, 5, 4]
    update!(suite, roll)
end

# 機関車問題
type Train <: Suite
    pmf::Pmf
    function Train{T}(hypos::Array{T})
        new(Pmf(hypos))
    end
end

function likelihood(train::Train, data, hypo)
    if hypo < data
        0
    else
        1.0 / hypo
    end
end
