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
