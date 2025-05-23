println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
model = Model(Ipopt.Optimizer)

d = 3
n = 20
m  = 5*(4-3*(d-2))

start_idx =2
t = 3^5 - 5*(3^5) + 5*(3^3) 
#m

@variable(model, -d <= λ[i = start_idx:n] <= d)

 set_start_value(λ[2], 1)
set_start_value(λ[3], -2)
set_start_value(λ[4], 1)
set_start_value(λ[5], -2)
# set_start_value(λ[6], -2)
# set_start_value(λ[7], 0)
# set_start_value(λ[8], -2)
# set_start_value(λ[9], 4)
# set_start_value(λ[10], 0)
# set_start_value(λ[11], 0)
# set_start_value(λ[12], 0)

# (m*(λ[i]^3))
@objective(model, Max, t + sum((λ[i]^5) - (5 * (λ[i]^4)) + (5*(λ[i]^3)) for i in start_idx:n) )

@constraint(model,  3 + sum(λ[i] for i in start_idx:n) == 0)
@constraint(model, 9 + sum(λ[i]^2 for i in start_idx:n) == n * d)
#@constraint(model, 12*sum((d-λ[i])*(d-λ[i]-1) for i in start_idx) == ((sum(d-λ[i] for i in start_idx)))^2)
println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)

