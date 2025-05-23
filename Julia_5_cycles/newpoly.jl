println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
model = Model(Ipopt.Optimizer)

d = 10
n = 25
#m  = 5*(4-3*(d-2))

start_idx =2
#t = 3^5 - 5*(3^5) + 5*(3^3) 
# 5-cycles 
t = d^7 +(-7*d + 7)*d^5
# 6-cycles
#t = d^6 + (d-6*d)*d^4 - 6*d^3
#m
# 7 cycles with ineqs
#t = d^7 + (7-7*d)*d^5 + (35*d^2 - 49*d + 28)*d^3

@variable(model, -d <= λ[i = start_idx:n] <= d)
#set_start_value(λ[2], d)
#set_start_value(λ[3], d)
#set_start_value(λ[4], -1)
#set_start_value(λ[5], d)
# set_start_value(λ[6], d)
# set_start_value(λ[7], d)
# set_start_value(λ[8], d)
# set_start_value(λ[9], d)
# set_start_value(λ[10], d)
# set_start_value(λ[11], d)
# set_start_value(λ[12], d)

# 1.63800e+04 > 6.66545e+03

# (m*(λ[i]^3))
# 5 cycles
@objective(model, Max, t + sum(λ[i]^7 + (-7*d + 7)*λ[i]^5 for i in start_idx:n))
# 6 cycles
#@objective(model, Max, t + sum(λ[i]^7 + (7-7*d)*λ[i]^5 + (35*d^2 - 63*d + 28)*λ[i]^3
#for i in start_idx:n))


@constraint(model,  d + sum(λ[i] for i in start_idx:n) == 0)
@constraint(model, d^2 + sum(λ[i]^2 for i in start_idx:n) == n * d)
@constraint(model, d^3 + sum(λ[i]^3 for i in start_idx:n) == 0) # Triangle free constraint
#@constraint(model, λ[i] == -4 || λ[i] == -sqrt(15) || λ[i] == -sqrt(14) || λ[i] == -sqrt(13) || λ[i] == -sqrt(12) || λ[i] == -sqrt(11) || λ[i] == -sqrt(10) || λ[i] == -3 || λ[i] == -sqrt(8) || λ[i] == -4 || λ[i] == -sqrt(7) || λ[i] == -sqrt(6) || λ[i] == -sqrt(5) || λ[i] == -2 || λ[i] == -sqrt(3) || λ[i]==-sqrt(2) || λ[i] == -1 || λ[i]==0 || λ[i] == 4 || λ[i] == sqrt(15) || λ[i] == sqrt(14) || λ[i] == sqrt(13) || λ[i] == sqrt(12) || λ[i] == sqrt(11) || λ[i] == sqrt(10) || λ[i] == 3 || λ[i] == sqrt(8) || λ[i] == 4 || λ[i] == sqrt(7) || λ[i] == sqrt(6) || λ[i] == sqrt(5) || λ[i] == 2 || λ[i] == sqrt(3) || λ[i]==sqrt(2) || λ[i] == 1 for i in start_idx:n)
#@constraint(model, 12*sum((d-λ[i])*(d-λ[i]-1) for i in start_idx) == ((sum(d-λ[i] for i in start_idx)))^2)
println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)