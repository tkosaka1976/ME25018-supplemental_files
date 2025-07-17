require "csv"
require 'optparse'

params = ARGV.getopts("","out_d:","ref:","base:","cut_off:")
#params["in"]

in_fn = "#{params["out_d"]}/#{params["base"]}-mod.csv"
ref_fn = "#{params["out_d"]}/#{params["base"]}-conserve_cls.csv"
cut_off = params["cut_off"].to_f

out_fn = "#{params["out_d"]}/#{params["base"]}-ccl&cls.csv"

csv = CSV.read(in_fn, headers: true)
csv_r = CSV.read(ref_fn, headers: true)
# "tc_id"

tc_list = csv["tc_id"].uniq.delete_if { it == "CX1" }.sort
cl_list = csv_r["cluster_id"]
ccl_data = {}
tc_list.each do |tc|
  result = []
  csv_r[tc].each_with_index do |e,i|
    result << cl_list[i] if e.to_f >= cut_off
  end
  ccl_data[tc] = result.join("|")
end

tc_convert = {}
ccl_data.sort_by{|k,v|v}.each_with_index do |(k,_),i|
  tc_convert["CC#{"%02d" % (i+1)}"] = k
end

out_f =File.open(out_fn, "w")

out_f.puts %w(new_tc_id tc_id ccl).to_csv
tc_convert.each do |k,v|
  out_f.puts [k,v,ccl_data[v]].to_csv
end

  
