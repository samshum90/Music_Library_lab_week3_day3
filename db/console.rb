require("pry")
require_relative("../models/album")
require_relative("../models/artist")

Album.delete_all
Artist.delete_all


artist1 = Artist.new( {'name' => 'Nirvana'} )
artist2 = Artist.new( {'name' => 'Oasis'} )

artist1.save
artist2.save

album1 = Album.new( {'title' => 'Nevermind', 'genre' => 'grunge', 'artist_id' => artist1.id} )
album2 = Album.new( {'title' => 'In utero', 'genre' => 'grunge', 'artist_id' => artist1.id} )

album1.save
album2.save

artist1.name = 'Iron Maiden'
artist1.update


album1.genre = 'metal'
album1.update

binding.pry
nil
