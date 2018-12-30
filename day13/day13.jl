using DelimitedFiles

struct CharChar
    a::Char
    b::Char
end

struct CharString
    a::Char
    b::String
end

mutable struct Cart
    id::Int8
    position::CartesianIndex
    symbol::Char
    mod_turns::Int8
    alive::Bool
end

function islesscart(c1::Cart,c2::Cart) :: Bool
    return c1.position[1]<c2.position[1] || (c1.position[1]==c2.position[1] && c1.position[2]<c2.position[2]) 
end

up = '^'
down = 'v'
left = '<'
right = '>'

vertical = '|'
horizontal = '-'
curve_backslash = '\\'
curve_slash = '/'
intersection = '+'
track_symbols = [vertical,horizontal,curve_slash,curve_backslash,intersection]
carts_symbols = [up,down,left,right]
directions = ["left","straight","right"]

straightMoves = Dict{Char,CartesianIndex}(
    up=>CartesianIndex(-1,0),
    down=>CartesianIndex(1,0),
    left=>CartesianIndex(0,-1),
    right=>CartesianIndex(0,1))
curves = Dict{CharChar,Char}(
    CharChar(up,curve_slash)=>right,
    CharChar(up,curve_backslash)=>left,
    CharChar(down,curve_slash)=>left,
    CharChar(down,curve_backslash)=>right,
    CharChar(left,curve_slash)=>down,
    CharChar(left,curve_backslash)=>up,
    CharChar(right,curve_slash)=>up,
    CharChar(right,curve_backslash)=>down)

turns = Dict{CharString,Char}(
    CharString(up,"left")=>left,
    CharString(up,"right")=>right,
    CharString(down,"left")=>right,
    CharString(down,"right")=>left,
    CharString(left,"left")=>down,
    CharString(left,"right")=>up,
    CharString(right,"left")=>up,
    CharString(right,"right")=>down
)

function solve(input)
    raw = readdlm(input,'\n',String)
    n_col = length(raw[1])
    n_row = length(raw)
    grid = Array{Char,2}(undef,n_row,n_col)
    for y in 1:n_row
        for x in 1:n_col
            grid[y,x] = raw[y][x]
        end
    end
    carts=Array{Cart,1}()
    cart_id=1
    for cart_position in findall(c->c in carts_symbols,grid)
        symbol = grid[cart_position]
        push!(carts,Cart(cart_id,cart_position,symbol,0,true))
        if symbol in carts_symbols[1:2]
            grid[cart_position] = vertical
        else 
            grid[cart_position] = horizontal
        end
        cart_id+=1
    end
    #@show carts
    #display(grid,carts)
    tick = 0
    while length(carts)>1
        carts=sort(carts,lt=islesscart)
        #@show carts
        #@show tick
        for cart in carts
            #@show (cart.id,cart.position)
            move(cart,grid)
            carts = crash(carts)
        end
        tick += 1
    end
    if length(carts)==1
        pos = carts[1].position
        x=pos[2]-1
        y=pos[1]-1
        println("Last alive cart position: (X,Y)=($x,$y) id $(carts[1].id)")
    end
end

function display(grid,carts)
    displayed = copy(grid)
    for cart in carts
        if displayed[cart.position] in carts_symbols
            displayed[cart.position]='X'
        else
            displayed[cart.position]=cart.symbol
        end
    end
    for row in 1:size(displayed)[1]
        println(join(displayed[row,:]))
    end
    println("")
end

function move(cart::Cart, grid)
    if cart.alive
        cart.position += straightMoves[cart.symbol]
        next_position = grid[cart.position]
        if next_position in track_symbols[3:4]
            cart.symbol = curves[CharChar(cart.symbol,next_position)]
        elseif next_position == intersection
            cart.mod_turns = (cart.mod_turns % length(directions)) + 1
            next_direction = directions[cart.mod_turns]
            if next_direction != "straight"
                cart.symbol = turns[CharString(cart.symbol,next_direction)]
            end
        end
    end
end

function crash(carts)
    num_carts = length(carts)
    for i in 1:num_carts-1
        cart1 = carts[i]
        for j in i+1:num_carts
            cart2 = carts[j]
            if cart1.position == cart2.position
                cart1.alive = false
                cart2.alive = false
                x=cart1.position[2]-1
                y=cart1.position[1]-1
                println("new crash ! (X,Y)=($x,$y) cart ids $(cart1.id) $(cart2.id)")
                return filter(c->c.alive,carts) 
            end
        end
    end
    return carts
end

#solve("input_test.txt")
#solve("input_test.2.txt")
solve("input.txt")


