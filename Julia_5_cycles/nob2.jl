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
k=7

t =  sum(
    binomial(k, floor(Int(2i))) * 4 * (d/2)^(k-2i) * ((d^2 - 4*(d-1))^i)/(2^(2i)) for i in 1:floor(k/2))

@variable(model, -d <= λ[i = start_idx:n] <= d)

@objective(model, Max, t + sum(
    sum(
        binomial(k, floor(Int(2i))) * 4 * (λ[j]/2)^(k-2i) * ((λ[j]^2 - 4*(d-1))^i)/(2^(2i)) 
        for i in 1:floor(k/2)
    ) 
    for j in start_idx:n
))
#8.57829e+06

# 8.57829e+06 but this point is not feassible since need one of the lambdas to be 0.
# set_start_value(λ[2], 0)
# set_start_value(λ[3], 0)
# set_start_value(λ[4], 0)
# set_start_value(λ[5], 0)
# set_start_value(λ[6], 0)
# set_start_value(λ[7], 3.1)
# set_start_value(λ[8], 3.1)
# set_start_value(λ[9], -8.1)
# set_start_value(λ[10], -8.1)


@constraint(model, d + sum(λ[i] for i in start_idx:n) == 0)
@constraint(model, d^2 + sum(λ[i]^2 for i in start_idx:n) == n * d)
@constraint(model, d^3 + sum(λ[i]^3 for i in start_idx:n) == 0)

println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)
