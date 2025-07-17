using Clustering
using CSV
using DataFrames
using Distances
using Statistics
using Plots

in_fn = "MEGA-result0-fill_nil.csv"

df = DataFrame(CSV.File(in_fn; drop=["0"]))

accessions = names(df)

data_matrix = collect(Matrix(df[:, 1:size(df)[2]]))

distance = SqEuclidean();
dmat = convert(Array{T} where T <: AbstractFloat, pairwise(distance, data_matrix, dims=2));

s_score_df = DataFrame(); out_df = DataFrame()
out_df[!, "accession"] = accessions;

check_cluster_size = 50;

println("Check cluster size: ", check_cluster_size, "\n")
for cluster_size in 2:check_cluster_size
    println(cluster_size)
    result = kmeans(data_matrix, cluster_size) # clustering はここだけ。
    out_df[!, Symbol(cluster_size)] = result.assignments
    s_scores = silhouettes(result.assignments, result.counts, dmat);
    s_score_df[!, Symbol(cluster_size)] = s_scores
end

#out_df;

CSV.write("hydrogenase_c0-mega-k_mean-results.csv", out_df);

median_a = [median(col) for col = eachcol(s_score_df)];

Plots.plot(2:check_cluster_size, median_a, t=:scatter, xlabel="cluster size", ylabel="s_score", markersize=3, c="black")

png("hydrogenase-mega-k_mean_size-result.png")


