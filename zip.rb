# -*- encoding : utf-8 -*-
require 'rubygems'
require 'zip'

all_files = Dir["/home/murillo/Downloads/gamebanana/files.gamebanana.com/maps/*"]

all_files.each do |zip_file_name|
	if zip_file_name.include?(".7z")
		`7z e #{zip_file_name} *.bsp *.nav -r`
	end
	if zip_file_name.include?(".zip")
		`unzip -j #{zip_file_name} '*.bsp'`
		`unzip -j #{zip_file_name} '*.nav'`
	end
	if zip_file_name.include?(".rar")
		rar_files = `unrar lb #{zip_file_name}`
		ar = rar_files.split("\n")
		ar.each do |file|
			if file.include?(".bsp") || file.include?(".nav")
				system("unrar e #{zip_file_name} #{file} >/dev/null")
			end
		end
	end
end
