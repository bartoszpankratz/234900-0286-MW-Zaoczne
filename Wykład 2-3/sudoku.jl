# This code solves Project Euler Problem 96

using HTTP

function getpuzzles()
    url = "https://projecteuler.net/project/resources/p096_sudoku.txt"
    filename = "p096_sudoku.txt" 
    if !isfile(filename) # download only if needed
        println("File not found. Fetching from a remote location ...")
        try
            # this uses OS tools and might fail if they are not found
            download(url, filename)
        catch
            # thus we provide a fallback
            r = HTTP.get(url)
            write(filename, r.body)
        end
    end
    nothing
end

blockvalid(x, v) = count(isequal(v), x) ≤ 1

function backtrack!(x)
    pos = findfirst(isequal(0), x)
    isa(pos, Nothing) && return true
    iloc = 3div(pos[1]-1, 3) .+ (1:3)
    jloc = 3div(pos[2]-1, 3) .+ (1:3)
    for k in 1:9
        x[pos] = k
        blockvalid(view(x, pos[1], :), k) || continue
        blockvalid(view(x, :, pos[2]), k) || continue
        blockvalid(view(x, iloc, jloc), k) || continue
        backtrack!(x) && return true
    end
    x[pos] = 0
    return false
end

function sudoku_solve(lines, idx)
    t = [lines[10idx-j][k] - '0' for j in 8:-1:0, k in 1:9]
    backtrack!(t)
    sum([100, 10, 1] .* t[1, 1:3])
end

function solve_all()
    getpuzzles()
    lines = readlines("p096_sudoku.txt")
    sum(sudoku_solve(lines, i) for i in 1:50)
end

solve_all()
