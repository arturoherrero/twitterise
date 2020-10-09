require "sequel"

class SQLiteAdaptor
  def self.database
    Sequel.connect("sqlite://#{database_path}")
  end

  def self.create_datablase
    self.database.create_table(:following) do
      Integer    :user_id
      Time       :created_at
      FalseClass :unfollowed
    end
  end

  private_class_method def self.database_path
    File.expand_path("../../db/twitterise.db", __dir__)
  end
end
