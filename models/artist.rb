require('pg')

require_relative('../db/sql_runner.rb')
require_relative('album.rb')


class Artist

  attr_reader :id
  attr_accessor :name

  def initialize ( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    sql = "INSERT INTO artists
            (name)
              VALUES
              ($1)
              RETURNING id"
      values = [@name]
      @id = SqlRunner.run(sql, values)[0]["id"].to_i
   end

   def self.all
     sql = "SELECT * FROM artists"
     artists = SqlRunner.run(sql)
     return artists.map { |artist| Artist.new(artist) }
   end

   def self.delete_all
     sql = "DELETE FROM artists"
     SqlRunner.run(sql)
   end

   def self.find(id)
     sql = "SELECT * FROM artists WHERE id = $1"
     values = [id]
     result = SqlRunner.run(sql, values)
     artist_hash = result.first
     artist = Artist.new(artist_hash)
     return artist
   end

   def get_albums()
     sql = "SELECT * FROM albums
            WHERE artist_id = $1;"
     values = [@id]
     result = SqlRunner.run(sql, values)
     return result.map {|album| Album.new(album)}
   end

   def update()
     sql = "
     UPDATE artists SET
      name = $1
     WHERE id = $2"
     values = [@name, @id]
     SqlRunner.run(sql, values)
   end

   def delete()
     sql = "DELETE FROM artists WHERE id = $1"
     values = [@id]
     SqlRunner.run(sql, values)
   end


end
