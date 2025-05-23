using JuMP, Ipopt, LinearAlgebra

# Constants
n = 20
d = 9

# Define the model
model = Model(Ipopt.Optimizer)

# Variables
@variable(model, -d <= x[1:n] <= d) # Variables x_i with bounds
@variable(model, v[1:n, 1:n])       # Matrix V representing vectors v_i

# Constraints
@constraint(model, sum(x[i] for i in 1:n) == 0)
@constraint(model, sum(x[i]^2 for i in 1:n) == 0)
@constraint(model, x[1] == d)       # x_1 = d


# Explicit normalization constraint for each vector v_i
@constraint(model, [i=1:n], sum(v[i, j]^2 for j in 1:n) == 1) # |v_i| = 1

# Orthonormality constraint for V: v_i ⋅ v_j = 0 for i ≠ j
@constraint(model, [i=2:n, j=1:i-1], sum(v[i, k] * v[j, k] for k in 1:n) == 0)

# Objective function
@objective(model, Max, sum(sum(sum((v[i, j]^2) * (v[i, k]^2) * (x[i]^7) for k in 1:n) for j in 1:n) for i in 1:n))

# Solve the model
optimize!(model)

# Extract results
optimal_x = value.(x)
optimal_v = value.(v)

println("Optimal x: ", optimal_x)
println("Optimal v: ", optimal_v)
