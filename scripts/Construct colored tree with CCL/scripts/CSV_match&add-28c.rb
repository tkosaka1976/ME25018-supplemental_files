require "csv"
require 'optparse'

params = ARGV.getopts("","out_d:","ref:","base:","cut_off:")

in_fn = "#{params["out_d"]}/#{params["base"]}-mod.csv"
ref_fn = "#{params["out_d"]}/#{params["base"]}-ccl&cls.csv"
out_fn = "#{params["out_d"]}/#{params["base"]}-mod_new_tc.csv"

in_csv = CSV.read(in_fn, headers: true)
ref_csv = CSV.read(ref_fn, headers: true)

key_in_col = "tc_id"
key_ref_col = "tc_id"
add_cols = %w(new_tc_id)

# extract array from csv at target column for index
ref_match_a = ref_csv[key_ref_col]

# export file name
out_csv = File.open(out_fn, "w")

# data addition to CSV
in_csv.each do |row|
  if ref_match_a.member?(row[key_in_col]) then
    ref_data = add_cols.map { |add| ref_csv[ref_match_a.index(row[key_in_col])][add] }
    row << Hash[add_cols.zip(ref_data)]
  else
    row << Hash[add_cols.zip(Array.new(add_cols.size, ""))]
  end
end

out_csv.puts in_csv
out_csv.close
