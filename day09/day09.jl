using DelimitedFiles

mutable struct Node
    value::Int64
    previous::Node
    next::Node
    Node(v) =(x=new(v); x.previous=x; x.next=x; x)
end

function solve(input)
    raw = readdlm(input,'\n')
    parties = map(parseParty,raw)
    for party in parties
        @show party
        play(party[1],party[2])
        play(party[1],party[2]*100)
    end
end

function parseParty(s)
    m = match(r"(?<players>\d+) players; last marble is worth (?<points>\d+) points", s)
    players = tryparse(Int64,m[:players])
    points = tryparse(Int64,m[:points])
    return [players points]
end

function play(num_players, num_points)
    circle=Node(0)  
    current = circle
    player = 1
    scores = zeros(Int64,num_players)
    for marble in 1:num_points
        if marble % 23 == 0
            scores[player]+= marble
            for i in 1:7
                current = current.previous
            end
            scores[player]+= current.value
            current.previous.next = current.next
            current.next.previous = current.previous
            current=current.next
        else
            current = current.next
            new_node = Node(marble)
            new_node.next = current.next
            new_node.previous = current
            current.next.previous = new_node
            current.next = new_node
            current = new_node
        end
        player = (player + 1 ) % num_players + 1
    end
    result = maximum(scores)
    @show result
end

solve("input.txt")
