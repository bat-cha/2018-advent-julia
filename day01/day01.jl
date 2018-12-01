
using DelimitedFiles


function solve(frequencyStart,input)
    changes = readdlm(input)
    # part 1
    finalFrequency = frequencyStart + sum(changes)
    println("final frequency: $finalFrequency")
    # part 2
    frequency = frequencyStart
    reached = Set()
    iteration = 0
    num_changes = length(changes)
    while ! in(frequency,reached)
        push!(reached,frequency)
        frequency+=changes[iteration%num_changes+1]
        iteration+=1
    end
    println("first duplicated frequency: $frequency at iteration $iteration")
end



solve(0,"input.txt")