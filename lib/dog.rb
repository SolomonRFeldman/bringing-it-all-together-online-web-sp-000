class Dog
  attr_accessor :id, :name, :breed
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def save
    sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.breed)
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end
  
  def self.find_by_id(id)
    dog_data = DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", id).first
    Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
  end
  
  def self.find_or_create_by(name:, breed:)
    if !(dog_data = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? breed = ?", name, breed).first).empty
      Dog.new(id: dog_data[0], name: dog_data[1], breed: dog_data[2])
    else
      Dog.create(name: name, breed: breed)
    end
  end
      
      
  
  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end
  
end