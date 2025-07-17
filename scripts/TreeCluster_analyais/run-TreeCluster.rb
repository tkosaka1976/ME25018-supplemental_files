require 'open3'
Dir.chdir  __dir__

in_dn = "nwk_input"

#command = "/Users/kousaka_tomoyuki/.pyenv/shims/TreeCluster.py"
command = "/Users/tomoyukikosaka/.pyenv/shims/TreeCluster.py"
magnification = 0.05
round = 2
from_to = 1..20

out_d = "data_output"
Dir.mkdir out_d unless Dir.exist? out_d

Dir.glob("#{in_dn}/*.nwk").each do |in_fn|
  p in_fn
  in_bn = File.basename(in_fn,".nwk")

  from_to.each do |i|
    threthold = (i * magnification).round(round)
  
    %w(avg_clade leaf_dist_avg leaf_dist_max leaf_dist_min length length_clade max max_clade med_clade root_dist single_linkage single_linkage_cut single_linkage_union sum_branch sum_branch_clade).each do |method|
      p Open3.capture3("#{command} -i #{in_fn} -o #{out_d}/#{method + threthold.to_s + "-" + in_bn}.txt -m #{method} -t #{threthold}")
    end
  end
end