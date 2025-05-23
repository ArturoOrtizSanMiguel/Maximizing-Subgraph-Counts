using LinearAlgebra  # For complex square roots
println("\n \n \n \n \n \n \n \n ================ \n \n \n \n \n \n \n")
using JuMP, LinearAlgebra, Ipopt
using DynamicPolynomials
using SumOfSquares
# model = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
model = Model(Ipopt.Optimizer)


function op(lam, c, d, k)
    if lam <= 0
        return 0
    end

    # Calculate the terms once to avoid repetition
    inner_term = lam^2 - (c - 1) - (d - 1)
    sqrt_term = sqrt(inner_term^2 - 4 * (c - 1) * (d - 1) + 0im)

    # Calculate the four possible values
    pp = sqrt((d - 1) * (inner_term + sqrt_term) / (2 * (c - 1)) + 0im)
    pn = sqrt((d - 1) * (inner_term - sqrt_term) / (2 * (c - 1)) + 0im)
    np = -pp
    nn = -pn

    # Return the sixth powers of each value
    return pp^(2 * k) + pn^(2 * k) + np^(2 * k) + nn^(2 * k)
end


d = 19
n = 60

t = op(d, 2, d, 7)

@variable(model, -d <= λ[i = start_idx:n] <= d)

@objective(model, Max, t + sum(op(λ[i], 2, d, 7)
for i in start_idx:n))


@constraint(model,  d + sum(λ[i] for i in start_idx:n) == 0)
@constraint(model, d^2 + sum(λ[i]^2 for i in start_idx:n) == n * d)

println(model) # view objective and constraints 
optimize!(model) # run optimization 
solution_summary(model; verbose = true)