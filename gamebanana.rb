# -*- encoding : utf-8 -*-
require 'rubygems'
require 'zip'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

agent = Mechanize.new

1.upto(8) do |i|
	url = "https://gamebanana.com/maps/cats/25?vl[page]=#{i}&mid=SubmissionsList&vl[preset]=hall_of_fame&vl%5Border%5D=views&vl%5Bfilters%5D%5Bviews%5D%5Bval%5D=10000&vl%5Bfilters%5D%5Bviews%5D%5Boptions%5D%5Boperator%5D=greater_than&vl%5Bfilters%5D%5Brating%5D=9-10"
	# url = "http://gamebanana.com/maps/cats/25?vl[page]=#{i}&mid=SubmissionsList&vl%5Bpreset%5D=hall_of_fame&vl%5Border%5D=views&vl%5Bfilters%5D%5Bviews%5D%5Bval%5D=10000&vl%5Bfilters%5D%5Bviews%5D%5Boptions%5D%5Boperator%5D=greater_than&vl%5Bfilters%5D%5Brating%5D=9-10"
	page = agent.get(url)
	puts "Página #{i} do GameBanana: Counter Strike Source - Categoria: Bomb/Defuse..."
	page.search('td.Preview a.Name').each do |p|
		href = p['href']
		puts "Encontrado link para o mapa: #{href}"
		id = href.split("/").last
		puts "Extraindo ID do mapa: #{id}"
		new_href = "http://gamebanana.com/maps/download/#{id}"
	  if new_href
	    puts "Entrando na página de download: #{new_href}..."
	    download_page = agent.get(new_href)
	    link = download_page.search('.MainDownloadModule .Content a').last
	    if link
	      puts "Link de download capturado..."
	      agent.pluggable_parser.default = Mechanize::FileSaver
	      puts "Downloading: #{link['href']}..."
	      agent.get(link['href'])
	      puts "Download Completo..."
	    end
	  end
		puts "========================================================================="
	end
end

puts "Começando a extração dos dados..."
all_files = Dir["/home/murillo/Downloads/gamebanana/files.gamebanana.com/maps/*"]
puts "#{all_files.size} mapas baixados..."
all_files.each do |zip_file_name|
	puts "Extraindo arquivo #{zip_file_name}..."
	if zip_file_name.include?(".7z")
		`7z e #{zip_file_name} *.bsp *.nav -r -aoa`
	end
	if zip_file_name.include?(".zip")
		`unzip -o -j #{zip_file_name} '*.bsp'`
		`unzip -o -j #{zip_file_name} '*.nav'`
	end
	if zip_file_name.include?(".rar")
		rar_files = `unrar lb #{zip_file_name}`
		ar = rar_files.split("\n")
		ar.each do |file|
			if file.include?(".bsp") || file.include?(".nav")
				system("unrar -o+ e #{zip_file_name} #{file} >/dev/null")
			end
		end
	end
	puts "Arquivo extraído com sucesso..."
	puts "========================================================================="
end
puts "Fim do script..."
