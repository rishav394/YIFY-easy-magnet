require 'restclient'	# => To open urls
require 'crack'			# => To parse string JSON
require 'clipboard'		# => To copy magnet link to Clipboard

reset = 1
while reset!=0
	puts "\nEnter the search query"
	nam = gets
	url="https://yts.am/api/v2/list_movies.json?query_term=#{nam}&sort_by=download_count"
	data= Crack::JSON.parse(RestClient.get(url))
	if data["data"]["movie_count"]!=0
		i=0
		while i<data["data"]["movie_count"] && i!=20
			puts "#{i+1}. #{data["data"]["movies"][i]["title_long"]}"	# => Long title also shows the date of release
			i+=1
		end
		puts "0/ENTER- Reset"
		puts "Enter your choice: "
		inp=gets
		inp=inp.to_i
		if inp>0 && inp<20
			quality_count=0
			puts
			data["data"]["movies"][inp-1]["torrents"].each do
				puts "#{quality_count+1}. #{data["data"]["movies"][inp-1]["torrents"][quality_count]["quality"]}"
				quality_count=quality_count+1
			end
			puts "Enter quality\n"
			i=gets
			i=i.to_i
			puts
			if i<1 || i>quality_count  # => quality range <=3 >1
				puts "Please Enter the correct number of the desired quality."
				puts "Resetting...\n"
			else
				TITLE=data["data"]["movies"][inp-1]["title_long"]		# => Long title also shows the date of release
				TORRENT_HASH=data["data"]["movies"][inp-1]["torrents"][i-1]["hash"]
				MLINK="magnet:?xt=urn:btih:#{TORRENT_HASH}&dn=ez&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopentor.org%3A2710&tr=udp%3A%2F%2Ftracker.ccc.de%3A80&tr=udp%3A%2F%2Ftracker.blackunicorn.xyz%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969"
				puts MLINK
				Clipboard.copy(MLINK)
				puts "\nCopied to clipboard successfully. Press Ctrl+V to paste. "
				xfile=File.open("Magnet.txt","w")
				xfile.write(TITLE)
				xfile.write("\n")
				xfile.write(MLINK)
				xfile.close						
				reset = 0
			end
		else
			puts "Resetting...\n"
		end
	else
		puts "\nPlease Enter correct search query matching on: \nMovie Title/IMDb Code, Actor Name/IMDb Code, Director Name/IMDb Code\n"
		puts "Resetting...\n"
	end
end
puts "\nPress Enter to continue"
gets