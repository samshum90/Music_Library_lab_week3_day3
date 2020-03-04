require('pg')

require_relative('../db/sql_runner.rb')
require_relative('album.rb')


class Album

  attr_reader :id
  attr_accessor :title, :genre, :artist_id

  def initialize ( options )
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @artist_id = options['artist_id'].to_i
  end

  def save
    sql = "INSERT INTO albums
            (title,
            genre,
            artist_id)
              VALUES
              ($1, $2, $3)
              RETURNING id"
      values = [@title, @genre, @artist_id]
      @id = SqlRunner.run(sql, values)[0]["id"].to_i
   end

   def self.all
     sql = "SELECT * FROM albums"
     albums = SqlRunner.run(sql)
     return albums.map { |album| Album.new(album) }
   end

   def self.delete_all
     sql = "DELETE FROM albums"
     SqlRunner.run(sql)
   end

   def self.find(id)
     sql = "SELECT * FROM albums WHERE id = $1"
     values = [id]
     result = SqlRunner.run(sql, values)
     album_hash = result.first
     album = Album.new(album_hash)
     return album
   end

   def album_by_artist(id)
     sql = "SELECT * FROM albums WHERE artist_id = $1"
     values = [id]
     result = SqlRunner.run(sql, values)
     album = result.map { |album| Album.new(album) }
     return album
   end

   # def self.find_album_by_artist_id(artist_id)
   #   sql = "SELECT * FROM albums WHERE artist_id = $1"
   #   values = [artist_id]
   #   result = SqlRunner.run(sql, values)
   #   album_hash = result.first
   #   album = Album.new(album_hash)
   #   return album
   # end

   # def self.find_by_artist(name)
   #   sql = "SELECT * FROM albums WHERE name = $1"
   #   values = [name]
   #   result = SqlRunner.run(sql, values)
   #   album_hash = result.first
   #   album = Album.new(album_hash)
   #   return album
   # end

   def update()
     sql = "
     UPDATE albums SET (
      title,
      genre,
      artist_id) =
      ( $1, $2, $3 )
     WHERE id = $4"
     values = [@title, @genre, @artist_id, @id]
     SqlRunner.run(sql, values)
   end

   def delete()
     sql = "DELETE FROM albums WHERE id = $1"
     values = [@id]
     SqlRunner.run(sql, values)
   end
end
