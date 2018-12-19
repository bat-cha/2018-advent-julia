using DelimitedFiles

function solve(input)
    raw = readdlm(input,'\n')
    coords = vcat(map(parseCoords,raw)...)
    best_time = 0
    smaller_height = height(coords,0)
    for time in 1:10460
        current_height = height(coords,time)
        if current_height < smaller_height
            smaller_height=current_height
            best_time = time
        end
    end
    @show best_time
    current = copy(coords[:,1:2])+best_time*coords[:,3:4]
    x_min,x_max = extrema(current[:,1])
    y_min, y_max = extrema(current[:,2])
    w = x_max-x_min+1
    h = y_max-y_min+1
    grid = fill(' ',(h,w))
    
    for point in 1:size(current)[1]
        grid[current[point,:][2]-y_min+1,current[point,:][1]-x_min+1]='#'
    end

    for line in 1:size(grid)[1]
        println(join(grid[line,:]))
    end
    
end

function parseCoords(s)
    m = match(r"position\=\<(?<x>.+),(?<y>.+)\> velocity\=\<(?<vx>.+),(?<vy>.+)\>", s)
    x = tryparse(Int64,m[:x])
    y = tryparse(Int64,m[:y])
    vx = tryparse(Int64,m[:vx])
    vy = tryparse(Int64,m[:vy])
    return [x y vx vy]
end

function height(coords,time)
    ymin,ymax = extrema(coords[:,2] + coords[:,4]*time)
    return ymax-ymin
end



solve("input.txt")
