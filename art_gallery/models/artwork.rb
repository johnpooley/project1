require_relative('../db/sql_runner.rb')

class Artwork

  attr_accessor :title, :exhibition, :artist, :date, :description, :image
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @exhibition = options['exhibition_id'].to_i
    @artist = options['artist_id'].to_i
    @date = options['date']
    @description = options['description']
    @image = options['image']
  end


  #############################################
  # CRUD

  # create

  def save()
    sql = "INSERT INTO artworks
    (
      title,
      exhibition_id,
      artist_id,
      date,
      description,
    image)
      VALUES ($1,$2,$3,$4,$5,$6)
      RETURNING id"
      values = [@title, @exhibition, @artist,
        @date, @description,@image]
        artwork = SqlRunner.run(sql, values).first
        @id = artwork['id'].to_i
  end

      def self.find(id)
        sql = "SELECT * FROM artworks
        WHERE id = $1"
        values = [id]
        results = SqlRunner.run(sql, values)
        return Artwork.new(results.first)
      end


      # read

      def self.all()
        sql = "SELECT artworks.* FROM artworks"
        artworks = SqlRunner.run(sql)
        results = artworks.map{|artwork| Artwork.new(artwork)}
        return results
      end

      # update

      def update()
        sql = "UPDATE artworks SET(
        title,
        exhibition_id,
        artist_id,
        date,
        description,
        image)
        = ($1,$2,$3,$4,$5,$6) WHERE id = $7"
        values = [@title, @exhibition, @artist,
          @date, @description, @image, @id]
          SqlRunner.run(sql, values)
        end

        # delete

        def self.delete_all()
          sql = "DELETE FROM artworks"
          SqlRunner.run(sql)
        end

        def delete()
          sql = "DELETE FROM artworks WHERE id = $1"
          values = [id]
          SqlRunner.run(sql, values)
        end

        ########################################################

        def artist()
          sql = "SELECT * FROM artists WHERE id = $1"
          values = [@artist]
          results = SqlRunner.run(sql, values)
          return Artist.new(results.first)
        end

        def exhibitionlist()
          sql = "SELECT * FROM exhibitions WHERE id = $1"
          values = [@exhibition]
          results = SqlRunner.run(sql, values)
          return Exhibition.new(results.first)
        end

end
