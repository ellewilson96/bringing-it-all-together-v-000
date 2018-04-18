require_relative "../config/environment.rb"

class Dog

  attr_accessor :name, :breed
  attr_reader :id

    def initialize(id: nil, name:, breed:)
      @id = id
      @name = name
      @breed = breed
    end

    def save
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end

    def self.create(name, breed)
      new_dog = Dog.new(name, breed)
      new_dog.save
      new_dog
    end

    def self.find_by_name(name)
      sql = "SELECT * FROM dogs WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Dog.new(result[0], result[1], result[2])
    end

    def self.new_from_db(row)
    id = row[0]
    name =  row[1]
    breed = row[2]
    self.new(id, name, breed)
    end

  def save
      if self.id
    self.update
    else
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
  end
  end

    def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogss (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
      SQL

      DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = "DROP TABLE IF EXISTS dogs"
      DB[:conn].execute(sql)
    end

    def update
      sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.breed, self.id)
    end

end
