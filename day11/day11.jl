using DelimitedFiles

function solve(input)
    raw = readdlm(input,'\n', Int16)
    serial_number=raw[1]
    @show search(serial_number,300,3:3)
    @show search(serial_number,300,1:300)
end

function compute_power_level(x,y,serial_number)
    rack_id = x + 10
    power_level = rack_id * y
    power_level += serial_number
    power_level *= rack_id
    power_level = floor(power_level%1000/100)
    power_level -= 5
end

@assert compute_power_level(3,5,8) == 4
@assert compute_power_level(122,79,57) == -5
@assert compute_power_level(217,196,39) == 0
@assert compute_power_level(101,153,71) == 4

function search(serial_number, grid_size, square_sizes)
    power_sum = zeros(Int32,grid_size,grid_size)
    x_max, y_max, square_size_max = 0,0,0
    for x in 2:grid_size
        for y in 2:grid_size
            power=compute_power_level(x,y,serial_number)
            power_sum[x,y] = power + power_sum[x,y-1] + power_sum[x-1,y] - power_sum[x-1,y-1];
        end
    end
    largest_total_power = 0
    for s in square_sizes
        for x in s+1:grid_size
            for y in s+1:grid_size
                #current = sum(grid[x:x+s-1,y:y+s-1])
                current = power_sum[x,y] - power_sum[x,y-s] - power_sum[x-s,y] + power_sum[x-s,y-s]
                if current > largest_total_power
                    largest_total_power = current
                    x_max = x
                    y_max = y
                    square_size_max = s
                end
            end
        end
    end
    return (x_max-square_size_max+1,y_max-square_size_max+1,square_size_max)
end
@assert search(18,300,3:3) == (33,45,3)
@assert search(42,300,3:3) == (21,61,3)
@assert search(18,300,1:300) == (90,269,16)
@assert search(42,300,1:300) == (232,251,12)


solve("input.txt")
