require "rubygems"
require "json"
require 'restclient'
require 'crack'
require 'io/console'
require "fileutils"


puts "Enter the search query"
nam = gets
url="https://yts.am/api/v2/list_movies.json?query_term=#{nam}&sort_by=seeds"
data= Crack::JSON.parse(RestClient.get(url))
i=0
while i<data["data"]["movie_count"]
	puts "#{i+1}. #{data["data"]["movies"][i]["title"]}"#+"\t\t\t"+data["data"]["movies"][i]["torrents"][0]["hash"]
	i+=1
end
inp=gets
inp=inp.to_i
TITLE=data["data"]["movies"][inp-1]["title"]
i=0
while i<data["data"]["movie_count"]
	if data["data"]["movies"][inp-1]["torrents"][i]["quality"]=="720p"
		break
	end
	i+=1
end
TORRENT_HASH=data["data"]["movies"][inp-1]["torrents"][i]["hash"]
MLINK="magnet:?xt=urn:btih:#{TORRENT_HASH}&dn=ez&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Fopentor.org%3A2710&tr=udp%3A%2F%2Ftracker.ccc.de%3A80&tr=udp%3A%2F%2Ftracker.blackunicorn.xyz%3A6969&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969"
puts MLINK
xfile=File.open("Magnet.txt","w")
xfile.write(MLINK)
xfile.close

gets