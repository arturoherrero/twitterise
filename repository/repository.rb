require_relative "../persistence/sqlite_adaptor"

class Repository
  def initialize(args = {})
    @database = args.fetch(:db) { SQLiteAdaptor.database }
  end

  def save_following(user_id)
    following_table.insert(
      :user_id    => user_id,
      :created_at => Date.today
    )
  end

  def following_after(days)
    following_table.where("created_at <= ?", Date.today - days).all.map do |row|
      row[:user_id]
    end
  end

  def following
    following_table.all.map do |row|
      row[:user_id]
    end
  end

  private

  attr_reader :database

  def following_table
    database[:following]
  end
end
