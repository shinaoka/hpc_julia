# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:percent
#     text_representation:
#       extension: .jl
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.6.0
#   kernelspec:
#     display_name: Julia 1.5.2
#     language: julia
#     name: julia-1.5
# ---

# %% [markdown]
# # 2D Ising model
#
# In this section, we move from the 1D Ising model to the 2D Ising model with the nearest-neighbor interaction.
# The Hamiltonian is given by
#
# $$
# \mathcal{H} = -\sum_{\langle\langle i, j\rangle\rangle} S_i S_j,
# $$
#
# where the sum runs over pairs of nearest-neighbor sites.
# The thermodynamic properties of the 2D Ising model are qualitatively different from those of the 1D model: The 2D model shows a continuous transitoin **at a finite temperature**.

# %%
@show VERSION
using BenchmarkTools, StaticArrays
using Random: default_rng, seed!

# %% [markdown]
# ## Very optimized implementation for nearest-neighbor 2D model
#
# In the cell below, you can find [a very optimized code for the 2D Ising model written by Gen Kuroki](https://nbviewer.jupyter.org/gist/genkuroki/79fd71a75b46303347bed4e52aaa2ba6).
# On my laptop (Macbook Pro 16-inchi 2019), using @invounds, @simd improves the performance around 7%.
# But, they are dropped in the cell below.
# The following code was modified from the original code to use the same update algorithm as in our 1D Ising code.

# %%
function ising2d_ifelse!(s, β, niters, rng=default_rng())
    m, n = size(s)
    min_h = -4
    max_h = 4
    prob = [1/(1+exp(-2*β*h)) for h in min_h:max_h]
    for iter in 1:niters
        for j in 1:n 
            for i in 1:m
                NN = s[ifelse(i == 1, m, i-1), j]
                SS = s[ifelse(i == m, 1, i+1), j]
                WW = s[i, ifelse(j == 1, n, j-1)]
                EE = s[i, ifelse(j == n, 1, j+1)]
                h = NN + SS + WW + EE
                s[i,j] = ifelse(rand(rng) < prob[h-min_h+1], +1, -1)
            end
        end
    end
end

const β_crit = log(1+sqrt(2))/2
rand_ising2d(m, n=m) = rand(Int8[-1, 1], m, n)

seed!(4649)
s₀ = rand_ising2d(100);

s = copy(s₀)
rng = default_rng()
ising2d_ifelse!(s, β_crit, 10, rng)

s = copy(s₀)
seed!(4649)
rng = default_rng()
@benchmark ising2d_ifelse!(s, β_crit, 10^3, rng)

# %% [markdown]
# ## Implementatin for general models
#
# We focus on the nearest-neighbor interaction in this section.
# But, you may want to introduce further neighbor interactions in the future.
# You will learn how to implement a general Monte Carlo code in this section.
# We first define a struc for storing the spatial structure of the interactions.

# %%
module MC

struct JModel
    connected_sites::Array{Int32,2}
    coord_num::Int8
end

# Compute effective field
compute_effective_field(s, ispin, jmodel) =
    sum((s[jmodel.connected_sites[j, ispin]] for j in 1:jmodel.coord_num))

function ising_update!(jmodel, s, β, niters, max_h, rng)
    num_spins = length(s)
    min_h = -max_h
    prob = [1/(1+exp(-2*β*h)) for h in min_h:max_h]
    h = 0
    for iter in 1:niters
        for ispin in 1:num_spins 
            h = compute_effective_field(s, ispin, jmodel)
            s[ispin] = ifelse(rand(rng) < prob[h-min_h+1], +1, -1)
        end
    end
end

end
;

# %% [markdown]
# Here we define a constructor for the nearest-neighbor 2D model.

# %%
"""
Constructor for a nearest-neighbor 2D
"""
function nn_model_2D(L)
    sites = Array{Int32,2}(undef, 4, L^2)
    to_site_idx(i,j) = mod1(i, L) + L*(mod1(j, L)-1)
    disp = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    for j in 1:L, i in 1:L
        isite = to_site_idx(i, j)
        for d in 1:4
           sites[d, isite] = to_site_idx(i+disp[d][1], j+disp[d][2])
        end
    end
    @assert all(sites .> 0)
    MC.JModel(sites, Int8(4))
end
;

# %%
L = 100
num_spins = L^2

model = nn_model_2D(L)
s = copy(vcat(s₀...))
seed!(4649)
rng = default_rng()
@benchmark MC.ising_update!(model, s, β_crit, 10^3, 4, rng)

# %% [markdown]
# This general code runs slower than the original code only by around 6% although the structure of the interactions is not hardcoded.

# %% [markdown]
# ## Exercise 1
#
# Simuate the nearest-neighbor 3D Ising model by implementing `nn_model_3D` based on `nn_model_2D`.

# %% [markdown]
# ## Exercise 2 (advanced)
#
# Introduce next nearest neighbor interaction $J_2$ by extending JModel and writing `nnn_model_2D` based on `nn_model_2D`.

# %%
