println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))

d = 4.0
n = 18
m  = 5*(4-3*(d-2))

start_idx =2
t = 4^5 - 5*(4^5) + m*(4^3) 
best_obj = -Inf 
best_model = Model(Ipopt.Optimizer)
best_k = 0
best_α = [0 ; 0]
for k in 1:n
    model = Model(Ipopt.Optimizer)
    

    @variable(model, -d <= α[i = 1:2] <= d)
    #@variable(model, 0 <= k <= n, Int)
    set_start_value(α[1], 2*k/n)
    set_start_value(α[2], -2*(n-k)/n)
    
    # set_start_value(λ[1], 2)
    # set_start_value(λ[2], -2)
    # set_start_value(λ[4], 0)
    # set_start_value(λ[5], -2)
    # set_start_value(λ[6], -2)
    # set_start_value(λ[7], 0)
    # set_start_value(λ[8], -2)
    # set_start_value(λ[9], 4)
    # set_start_value(λ[10], 0)
    # set_start_value(λ[11], 0)
    # set_start_value(λ[12], 0)


    @objective(model, Max, k*(α[1]^5 - 5*α[1]^4 - 10*α[1]^3)/n + (n-k)*(α[2]^5 - 5*α[2]^4 - 10*α[2]^3)/n)

    @constraint(model, k*α[1]/n + (n-k)*α[2]/n == -4/n)
    @constraint(model, k*α[1]^2 /n + (n-k)*α[2]^2 / n  == 4-12/n)
    println(model) # view objective and constraints 
    optimize!(model) # run optimization 
    solution_summary(model; verbose = true)
    # unregister(model, :α)
    if objective_value(model) > best_obj 
        global best_obj = objective_value(model)
        global best_model = copy(model)  
        global best_k = k 
        global best_α = value.(α)
    end
end