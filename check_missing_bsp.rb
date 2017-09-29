# -*- encoding : utf-8 -*-
require 'shellwords'

all_files = Dir["/home/murillo/.steam/steam/steamapps/common/Counter-Strike Source/cstrike/maps/*.nav"]

all_files.each do |file_name|
	true_name = file_name.chop.chop.chop.chop
	unless File.file?("#{true_name}.bsp")
		`rm -rf #{Shellwords.escape(file_name)}`
	end
end
