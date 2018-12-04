
using DelimitedFiles
using StatsBase

function solve(input)
    boxesIds = readdlm(input)
    vectorIds = map(vectorize, boxesIds)
    # part 1
    counts = map(letterCounts,vectorIds)
    groups = sum(counts)
    checksum = groups[1] * groups[2]
    println("checksum: $checksum")
    # part 2
    N = length(vectorIds)
    for i in 1:N
        for j in i+1:N
            diff = findall(!iszero,vectorIds[i]-vectorIds[j])
            if length(diff) == 1
                println(boxesIds[i])
                println(boxesIds[j])
                println("i $i j $j diff $diff")
                result = string(boxesIds[i][1:diff[1]-1],boxesIds[i][diff[1]+1:end])
                println("result: $result")
                break
            end
        end
    end
    
end

function vectorize(s)
    return Vector{UInt8}(s)
end

function letterCounts(v)
    c=counts(v)
    return [in(2,c),in(3,c)]
end

solve("input.txt")