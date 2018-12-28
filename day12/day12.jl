using DelimitedFiles

function solve(input,n_generation)
    raw = readdlm(input,'\n')
    initial_state = parse(raw[1])
    spread = Dict{String,String}(map(parse, raw[2:end]))
    state = string("...",initial_state,"...")
    state_sum = Int64(0)
    zero_index=4
    sum_diffs = zeros(Int16,42)
    current_gen = 1
    for generation in 1:n_generation
        next_state = Array{String,1}()
        for pot in 3:length(state)-2
            note = state[pot-2:pot+2]
            if note in keys(spread)
                push!(next_state,spread[note])
            else
                push!(next_state,".")
            end
        end
        next_state = string("...",join(next_state),"...")
        zero_index+=1
        next_state_sum = sum((findall(x->x=='#',next_state) .-zero_index))
        sum_diff = next_state_sum-state_sum
        popfirst!(sum_diffs)
        push!(sum_diffs,sum_diff)
        state = next_state
        state_sum = next_state_sum
        current_gen += 1
        if length(unique(sum_diffs))==1
            break
        end
    end
    if length(unique(sum_diffs))==1
        current_gen -= 1
        state_sum += sum_diffs[1]*(n_generation-current_gen)
    end
    @show state_sum
end

function parse(s)
    m = match(r"(initial state: (?<initialstate>.+)|(?<left>.+) => (?<right>.+))", s)
    initial_state = m[:initialstate]
    if initial_state!= nothing
        return initial_state
    else
        return (m[:left],m[:right])
    end
end


solve("input_test.txt",20)
solve("input.txt",20)
solve("input.txt",50000000000)
