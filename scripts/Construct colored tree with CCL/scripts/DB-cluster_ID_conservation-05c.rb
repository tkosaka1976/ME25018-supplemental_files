require "sequel"
require 'csv'
require 'optparse'

params = ARGV.getopts("","in:","out_d:","base:","db_d:")
#params["base"]

target_fn = "#{params["out_d"]}/#{params["base"]}-mod.csv"
#SequenceName ClusterName

target_csv = CSV.read(target_fn, headers: true)#, col_sep: "\t")
#p ref_csv.headers
cluster2locus_tags = Hash.new { |h,k| h[k]=[] }
target_csv.each do |row|
  cluster2locus_tags[row["tc_id"]] << row["SequenceName"]
end

#pp cluster2locus_tags

db = Sequel.sqlite params["db_d"]
base_table = :data
#join_col = :locus_tag
data_table = db[base_table]
#CREATE TABLE IF NOT EXISTS "data"(
#"Number" TEXT, "GenBank ID" TEXT, "position" TEXT, "gene" TEXT,
# "locus_tag" TEXT, "product" TEXT, "strain" TEXT, "taxonomy" TEXT,
# "aa seq." TEXT, "nt seq." TEXT, "old_locus_tag" TEXT, "RefSeq acc. No." TEXT,
# "cluster id" TEXT, "number of cluster member" TEXT, "clade id" TEXT, "Motif (Pfam)" TEXT,
# "Hydrogenase Class" TEXT);

results = {}
cluster2locus_tags.each do |clade_cluster, locus_tags|
  tenta_results = {}
  strains = data_table.where("locus_tag": locus_tags).select_map(:strain).uniq
  total_clusters = strains.inject([]) do |total_c, strain|
    cluster_ids = data_table.where(strain: strain).select_map(:"cluster id").map(&:to_i)
    total_c << cluster_ids
  end  
  total_clusters.flatten.tally.sort.each do |cluster, count|
    tenta_results[cluster] = count.to_f/strains.size
  end
  results[clade_cluster] = tenta_results
end

out_fn = "#{params["out_d"]}/#{params["base"]}-conserve_cls.csv"
out_f = File.open("#{out_fn}", "w")
out_f.puts ["cluster_id", cluster2locus_tags.keys].flatten.to_csv
cluster_ids = results.map{|k,v| v.keys }.flatten.uniq.sort
cluster_ids.each do |cluster_id|
  values = []
  cluster2locus_tags.keys.each do |cluster|
    values << results[cluster][cluster_id]
  end
  out_f.puts [cluster_id, values].flatten.to_csv
end

