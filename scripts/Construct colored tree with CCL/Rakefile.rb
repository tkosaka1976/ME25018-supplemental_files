# do rake -f on command line

#require 'date'
require 'shellwords'

# input information
newick_dn = "newick-files"
cluster_dn = "cluster-info"
output_dn = "outputs"
script_dn = "scripts"
db_n = "db/SDH_clustering_240416.sqlite"
ccl_cut_off = 0.9

file_pairs = {
  "avg_clade0.4-SdhA.txt" => "SdhA.nwk",
  #"avg_clade0.8-SdhB.txt" => "SdhB.nwk",
  "avg_clade0.4-SdhB.txt" => "SdhB.nwk",
}

desc "main loop"
task :default do
  
  file_pairs.each do |cluster_info, nwk|
    base = File.basename(cluster_info,".txt") + "-cut_#{ccl_cut_off}"
    Dir.mkdir "#{output_dn}/#{base}" unless Dir.exist? "#{output_dn}/#{base}"
    ruby "#{script_dn}/CSV-col_data_modify-02c.rb \\
          --in #{cluster_dn}/#{cluster_info} --out_d #{output_dn}/#{base} --base #{base}"
    ruby "#{script_dn}/DB-cluster_ID_conservation-05c.rb \\
          --base #{base} --out_d #{output_dn}/#{base} --db_d #{db_n}"
    ruby "#{script_dn}/CSV-sort_conserved_cls2newCCnumber-01c.rb \\
          --base #{base} --out_d #{output_dn}/#{base} --cut_off #{ccl_cut_off}"
    ruby "#{script_dn}/CSV-newcl_id_with_color-01c.rb \\
          --base #{base} --out_d #{output_dn}/#{base}"
    ruby "#{script_dn}/\"CSV_match&add-28c.rb\" \\
          --base #{base} --out_d #{output_dn}/#{base}"
    ruby "#{script_dn}/html_output_from_csvs-02c.rb \\
          --base #{base} --out_d #{output_dn}/#{base}"
    sh "rscript #{script_dn}/ggtree-make_colored_tree_with_info-04c.r \\
    --nwk #{newick_dn}/#{nwk} \\
    --info #{output_dn}/#{base}/#{base}-mod_new_tc.csv \\
    --clcolorccl \"#{output_dn}/#{base}/#{base}-ccl&cls&color.csv\" \\
    --outpng #{output_dn}/#{base}/#{base}-colored_tree.png"
  end
  
end

#rscript scripts/ggtree-make_colored_tree_with_info-03.r --nwk "newick-files/cluster-1.nwk" --info "outputs/avg_clade0.6-cluster-1/avg_clade0.6-cluster-1-mod.csv" --clcolorccl "outputs/avg_clade0.6-cluster-1/avg_clade0.6-cluster-1-cl&color&cls.csv" --outpng "outputs/avg_clade0.6-cluster-1/avg_clade0.6-cluster-1-colored_tree.png"
#どうやら&は切れるみたいで、ダブルクォーテーションで囲まないといけない。