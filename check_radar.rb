# -*- encoding : utf-8 -*-
require 'pp'
require 'shellwords'

all_files = Dir['/home/murillo/.steam/steam/steamapps/common/Counter-Strike Source/cstrike/maps/*.bsp']
# all_files = Dir['/home/murillo/Downloads/gamebanana/*.bsp']

puts "Analisando radar nos mapas..."
radar_files = []
all_files.each do |zip_file_name|
	puts "Mapa: #{zip_file_name}..."
	# return_string = `hexdump -C #{zip_file_name} | grep radar`
	return_string = `awk '/overviews/ {
	    match($0, /overviews/); print substr($0, RSTART - 10, RLENGTH + 20);
	}' #{Shellwords.escape(zip_file_name)}`
	if return_string.empty?
		puts "Mapa: #{zip_file_name} não possui radar... ={"
		puts "Checando se é um mapa for fun..."
		if zip_file_name.include?("fy_") || zip_file_name.include?("gg_") || zip_file_name.include?("aim_") || zip_file_name.include?("3mc_")
			puts "Mapa For Fun, não será deletado..."
		else
			puts "Deletando Mapa..."
			`rm -rf #{Shellwords.escape(zip_file_name)}`
		end
	else
		puts "Mapa: #{zip_file_name} possui radar... =}"
		radar_files << zip_file_name
	end
	puts "========================================================================="
end
p "Análise completa..."
puts "========================================================================="
p "Mapas com radar: #{radar_files.size}"
pp radar_files
puts "========================================================================="
