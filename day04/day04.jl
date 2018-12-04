
using DelimitedFiles
using Dates
using StatsBase

df = DateFormat("yyyy-mm-dd HH:MM")

function solve(input)
    raw = readdlm(input,'\n')
    shifts = []
    guardIDs = Array{Int16,1}()
    mapreduce(parseShift, fillShifts, raw, init=(shifts,guardIDs))
    sort!(shifts, by = x -> x[1])
    unique!(guardIDs)
    numGuards = length(guardIDs)
    guardIndices = Dict(zip(guardIDs,1:numGuards))
    reverseGuardIndices = Dict(zip(1:numGuards,guardIDs))
    #part 1
    sleepGrid = zeros(Int16,12,31,numGuards,60)
    lastGuardIndex = nothing
    lastGuardTimeStamp = nothing
    reduce(fillGrid, shifts, init=(lastGuardIndex,lastGuardTimeStamp,sleepGrid,guardIndices))
    @show sum(sleepGrid[:,:,:,:],dims=[1,2,4])
    sleepyGuardIndex = argmax(sum(sleepGrid[:,:,:,:],dims=[1,2,4]))[3]
    sleepyGuard = reverseGuardIndices[sleepyGuardIndex]
    println(sleepyGuard)
    sleepyMinute = argmax(sum(sleepGrid[:,:,sleepyGuardIndex,:],dims=[1,2]))[3] - 1
    println(sleepyMinute)
    part1=sleepyGuard*sleepyMinute
    println("result part 1: $part1")
    #part 2
    marmotte=argmax(sum(sleepGrid[:,:,:,:],dims=[1,2]))
    dormeur=reverseGuardIndices[marmotte[3]]
    minutemax=marmotte[4]-1
    part2=dormeur*minutemax
    println("result part 2: $part2")
end

function parseShift(s)
    m = match(r"\[(?<timestamp>.+)\] (Guard #(?<guardID>.+) begins shift|(?<sleeping>falls asleep$)|(?<awake>wakes up$))", s)
    t = DateTime(m[:timestamp],df)
    guardID = m[:guardID]
    if guardID!= nothing
        guardID = tryparse(Int16,guardID)
    end
    sleeping = (m[:sleeping]!=nothing)
    awake = (m[:awake]!=nothing)
    return (t,guardID,sleeping,awake)
end

function fillShifts((shifts,guardIDs),(t,guardID,sleeping,awake))
    if guardID!=nothing
        push!(guardIDs,guardID)
    end
    push!(shifts,(t,guardID,sleeping,awake))
    return (shifts,guardIDs)
end

function fillGrid((lastGuardIndex,lastGuardTimeStamp,grid,guardIndices),(timestamp,guardID,sleeping,awake))
    if guardID!=nothing
        lastGuardIndex=guardIndices[guardID]
    elseif sleeping
        grid[Dates.month(timestamp),Dates.day(timestamp),lastGuardIndex,Dates.minute(timestamp)+1]=1
    elseif awake
        sleepMinute = lastGuardTimeStamp
        while timestamp > sleepMinute
            sleepMinute = sleepMinute + Dates.Minute(1)
            grid[Dates.month(sleepMinute),Dates.day(sleepMinute),lastGuardIndex,Dates.minute(sleepMinute)+1]=1
        end
        grid[Dates.month(timestamp),Dates.day(timestamp),lastGuardIndex,Dates.minute(timestamp)+1]=0
    end
    lastGuardTimeStamp=timestamp
    return (lastGuardIndex,lastGuardTimeStamp,grid,guardIndices)

end

solve("input.txt")