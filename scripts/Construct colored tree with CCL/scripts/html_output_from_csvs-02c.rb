require "csv"
require 'optparse'

params = ARGV.getopts("","out_d:","base:")
#params["base"]

in_fn = "#{params["out_d"]}/#{params["base"]}-ccl&cls&color.csv"
out_fn = "#{params["out_d"]}/#{params["base"]}-cl_color.html"
out_f = File.open(out_fn, "w")

CSV.foreach(in_fn, headers: true) do |row|
  out_f.puts "<font color=\"#{row["color"]}\"><b>#{row["new_tc_id"]}</b> #{row["ccl"]}</font><br />"
end
