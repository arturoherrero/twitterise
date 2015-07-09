require "sequel"

class SQLiteAdaptor
  def self.database
    Sequel.connect("sqlite://#{database_path}")
  end

  def self.create_datablase
    self.database.create_table(:following) do
      Fixnum :user_id
      Time   :created_at
    end
  end

  private

  def self.database_path
    File.expand_path("../../../db/twitterise.db", __FILE__)
  end
end
