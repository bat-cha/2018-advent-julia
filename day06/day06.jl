using DelimitedFiles

function solve(input)
    raw = readdlm(input,'\n')
    coords =vcat(map(toInt,raw)...)
    @show coords
    num_points = length(coords[:,1])
    @show num_points
    x_min, x_max = extrema(coords[:,1])
    y_min, y_max = extrema(coords[:,2])
    @show (x_min, x_max, y_min, y_max)
    finite_indices = Set(collect(1:num_points))
    
    safe=zeros(Int16,num_points)
    best=zeros(Int16,num_points)

    for x in x_min:x_max
        for y in y_min:y_max
            distances = sum(abs.([x y] .- coords),dims=2)
            #@show (x,y,distances)
            #@show sum(distances)
            mindis = minimum(distances)
            allmins = findall(d->d==mindis,distances)
            if (length(allmins)==1)
                safe[allmins[1]]+=1
                if x == x_min || x==x_max || y==y_min || y==y_min
                    delete!(finite_indices,allmins[1][1])
                end

            end
            if sum(distances) < 10000
                best[allmins[1]]+=1
            end
        end
    end
    @show safe
    @show best
    @show finite_indices
    part1 = maximum(safe[collect(finite_indices)])
    part2 = sum(best)
    @show part1
    @show part2
end

function toInt(s)
    m = match(r"(?<x>\d+), (?<y>\d+)", s)
    x = tryparse(Int16,m[:x])
    y = tryparse(Int16,m[:y])
    return [x y]
end

solve("input.txt")