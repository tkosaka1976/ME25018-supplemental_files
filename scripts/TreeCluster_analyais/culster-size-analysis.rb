require 'csv'
#require 'shellwords'

target_d = 'data_output'

out_f = File.open("#{target_d}-summary.csv", "w")
out_f.puts %w(cluster_id method threshold cluster_size -1count name_count).to_csv
Dir.glob("#{target_d}/*.txt") do |in_fn|
  /\/(?<method>[a-z_]+?)(?<threshold>\d\.\d{1,2})\-SdhB\.txt$/ =~ in_fn
  csv = CSV.read(in_fn, col_sep:"\t", headers: true)
  clust_num_a = csv["ClusterNumber"].map(&:to_i) #"SequenceName"
  seq_name_a = csv["SequenceName"]
  out_f.puts [0, method, threshold, clust_num_a.max, clust_num_a.count(-1), seq_name_a.count(nil)].to_csv
end

  
  