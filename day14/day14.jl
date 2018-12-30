using DelimitedFiles

function solve(input)
    raw = readdlm(input,'\n', Int32)
    n_recipes=raw[1]
    @show n_recipes
    @time @show hotchocolate(n_recipes)
    @time @show hotchocolate_b(string(n_recipes))
end

function hotchocolate(n_recipes)
    scores=[3,7]
    elves=[1,2]
    for iteration in 1:n_recipes+10
        append!(scores,reverse(digits(sum(scores[elves]))))
        elves=((elves+(scores[elves])).%length(scores)).+1
        #@show scores
    end
    ten_scores = join(scores[n_recipes+1:n_recipes+10])
    return ten_scores
end

@assert hotchocolate(9)=="5158916779"
@assert hotchocolate(5)=="0124515891"
@assert hotchocolate(18)=="9251071085"
@assert hotchocolate(2018)=="5941429882"

function hotchocolate_b(input_str)
    scores=[3,7]
    elves=[1,2]
    while !occursin(input_str,join(view(scores,max(1,length(scores)-10):length(scores))))
        new_score=reverse(digits(sum(scores[elves])))
        append!(scores,new_score)
        elves=((elves+(scores[elves])).%length(scores)).+1
    end
    sequence = map(c->parse(Int8,c),collect(input_str))
    result = findfirst(input_str,join(scores))[1]-1
    return result
end

@assert hotchocolate_b("51589")==9
@assert hotchocolate_b("01245")==5
@assert hotchocolate_b("92510")==18
@assert hotchocolate_b("59414")==2018


solve("input.txt")