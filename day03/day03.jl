
using DelimitedFiles

function solve(input)
    claims = readdlm(input,'\n')
    fabric = fill([],(1000,1000))
    mapreduce(parseClaim, fillGrid, claims, init=fabric)
    # part 1
    surface = count(x->length(x)>1,fabric)
    println("square inches of fabric within 2 or more claims: $surface")
    # part 2
    mapreduce(parseClaim, checkClaim, claims, init=fabric)
    
end

function parseClaim(s)
    m = match(r"#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)", s)
    return tuple(map(parseInt,m.captures)...) 
end

function parseInt(s)
    return tryparse(Int16,s)
end

function fillGrid(fabric,(id,x,y,w,h))
    for i in x+1:(x+w)
        for j in y+1:(y+h)
            if length(fabric[i,j])==0
                fabric[i,j]=[id]
            else
                push!(fabric[i,j],id)
            end
        end
    end
    return fabric
end

function checkClaim(fabric,(id,x,y,w,h))
    nonoverlapping=true
    for i in x+1:(x+w)
        for j in y+1:(y+h)
            nonoverlapping=nonoverlapping&&(length(fabric[i,j])==1)
        end
    end
    if nonoverlapping
        println("Found claim $id")
    end
    return fabric
end

solve("input.txt")