using DelimitedFiles

function solve(input)
    raw = vcat(readdlm(input,Int16)...)
    p1 = process(copy(raw),aggregate)
    @show p1
    p2 = process(copy(raw),findRootValue)
    @show p2

end

function process(list, f)
    numChildren = popfirst!(list)
    numMeta = popfirst!(list)
    return f(ntimes(numChildren,list,f), splice!(list,1:numMeta))
end

function ntimes(n,list, f)
    result = Int16[]
    for i in 1:n
        push!(result,process(list,f))
    end
    return result
end

function aggregate(child,metadata)
    return sum(child) + sum(metadata)
end



function childValue((child,value),index)
    if length(child)>index
        value+=child[index+1]
    else
        value+= 0
    end
    return (child,value)
end

function findRootValue(child,metadata)
    pushfirst!(child,0)
    if length(child) == 1
        return sum(metadata)
    else
        return reduce(childValue,metadata,init=(child,0))[2]
    end
end

solve("input.txt")
