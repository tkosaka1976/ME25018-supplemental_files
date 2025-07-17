require "csv"
require 'optparse'

params = ARGV.getopts("","in:","out_d:","base:")
#params["base"]

in_fn = params["in"]
out_fn = "#{params["out_d"]}/#{params["base"]}-mod.csv"

csv = CSV.read(in_fn, headers: true, col_sep:"\t")

csv.delete_if do |row|
  row["SequenceName"] =~ /\(\d{1}\)/
end

csv.each do |row|
  modified =
  case row["ClusterNumber"]
  when "-1"
    "CX1"
  else
    "C" + ("%02d" % row["ClusterNumber"])
  end
  row << { "tc_id" => modified }
end

File.open(out_fn, "w"){ _1.puts csv }

