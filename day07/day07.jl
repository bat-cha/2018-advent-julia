using DelimitedFiles

function solve(input)
    raw = readdlm(input,'\n')
    dependencies = Dict{Char,Set{Char}}()
    reduce(parse,raw,init=dependencies)
    @show dependencies
    dependencies_copy = deepcopy(dependencies)
    #part 1
    assembly_order = []
    while !isempty(dependencies)
        _, next_task = minimum([(length(v),k) for (k,v) in dependencies])
        delete!(dependencies,next_task)
        for (_,v) in dependencies
            delete!(v,next_task)
        end
        push!(assembly_order,next_task)
    end
    @show join(assembly_order)
    #part 2
    dependencies = dependencies_copy
    assemblers = [[nothing,0] for _ in 1:5]
    task_delay = 60
    clock = 0
    for time in Iterators.countfrom(1,1)
        if isempty(dependencies) && all(assembler->(assembler[2]<=0),assemblers)
            break
        end
        for assembler in assemblers
            assembler[2]-=1
            if assembler[2]<=0
                if isempty(dependencies)
                    assembler[1]=nothing
                    assembler[2]=0
                    continue
                end
                if assembler[1] != nothing
                    for (_,v) in dependencies
                        delete!(v,Char(assembler[1]))
                    end
                end
            end
        end
        for assembler in assemblers
            if assembler[2]<=0
                if isempty(dependencies)
                    continue
                end
                tasks = [(length(v),k) for (k,v) in dependencies]
                deps, next_task = minimum(tasks)
                if deps>0
                    assembler[1]=nothing
                    assembler[2]=0
                    continue
                end
                delete!(dependencies,next_task)
                assembler[1] = next_task
                assembler[2] = (next_task-'A')+1+task_delay
            end
        end
        clock+=1
    end
    clock-=1
    @show clock
   
end

function parse(dependencies,s)
    m = match(r"Step (?<left>[A-Z]) must be finished before step (?<right>[A-Z]) can begin.", s)
    dependency = collect(m[:left])[1]
    task = collect(m[:right])[1]
    if haskey(dependencies,task)
        push!(dependencies[task],dependency)
    else
        dependencies[task]=Set([dependency])
    end
    if !haskey(dependencies,dependency)
        dependencies[dependency]=Set()
    end
    return dependencies
end


solve("input.txt")