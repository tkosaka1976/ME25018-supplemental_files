require "csv"
require "color-generator"
require 'optparse'

params = ARGV.getopts("","in:","out_d:","base:","cut_off:")
#params["base"]

in_fn = "#{params["out_d"]}/#{params["base"]}-ccl&cls.csv"
out_fn = "#{params["out_d"]}/#{params["base"]}-ccl&cls&color.csv"

c_generator = ColorGenerator.new saturation: 1.0, value: 0.7, seed: 1 #lightness: 0.75

csv = CSV.read(in_fn,headers:true)#, col_sep:"\t")
target_a = csv["new_tc_id"].uniq.sort

csv.each do |row|
  #unless row["new_tc_id"] == "CCX1"
  row << {color: "#" + c_generator.create_hex.upcase }
  #end
end

File.open(out_fn, "w") { it.puts csv }