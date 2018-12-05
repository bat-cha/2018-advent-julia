using DelimitedFiles
using DataStructures

function solve(input)
    raw = readdlm(input,'\n')
    s=raw[1]
    n_units = solvePart1(s,[])
    println("part 1 result: $n_units")
    n_units = solvePart2(s)
    println("part 2 result: $n_units")

end

function solvePart1(s,escape)
    result=[s[1]]
    for c in s[2:end]
        if findfirst(x->x==c,escape)==nothing
            if length(result)>0 && abs(result[end]-c)==32
                pop!(result)
            else
                push!(result,c)
            end
        end
    end
    n_units = length(result)
    return n_units
end

function solvePart2(s)
    ascii = [65:65+25...]
    searchGrid = []
    mapreduce(process,searchMin,ascii,init=(s,searchGrid))
    @show searchGrid
    return min(searchGrid...)
end

function process(codeChar)
    return [Char(codeChar),Char(codeChar+32)]
end

function searchMin((s,searchGrid),exclude)
    push!(searchGrid,solvePart1(s,exclude))
    return (s,searchGrid)
end

solve("input.txt")