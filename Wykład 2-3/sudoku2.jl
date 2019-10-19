using JuMP
using Cbc
using LinearAlgebra

# drop-in replacement of sudoku_solve from sudoku.jl

function sudoku_solve(lines, idx)
    t = [lines[10idx-j][k] - '0' for j in 8:-1:0, k in 1:9]
    m = Model(solver=CbcSolver())
    @variable(m, x[1:9, 1:9, 1:9], Bin)
    for i in 1:9, j in 1:9
        @constraint(m, sum(x[i, j, :]) == 1)
        @constraint(m, sum(x[i, :, j]) == 1)
        @constraint(m, sum(x[:, i, j]) == 1)
        t[i, j] > 0 && @constraint(m, x[i, j, t[i, j]] == 1)
    end
    for i in 0:2, j in 0:2, k in 1:9
        @constraint(m, sum(x[3i .+ (1:3), 3j .+ (1:3), k]) == 1)
    end
    solve(m)
    xv = getvalue(x)
    v = 100dot(1:9, xv[1,1,:]) + 10dot(1:9, xv[1,2,:]) + dot(1:9, xv[1,3,:])
    println(lines[10idx-9], ":\t", v)
    return v
end

