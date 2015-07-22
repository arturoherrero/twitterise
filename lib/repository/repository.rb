require_relative "../persistence/sqlite_adaptor"

class Repository
  def initialize(args = {})
    @database = args.fetch(:db) { SQLiteAdaptor.database }
  end

  def save_following(user_id)
    following_table.insert(
      :user_id    => user_id,
      :created_at => Time.now
    )
  end

  def following_after(days)
    following_table.where(
      "created_at BETWEEN ? AND ?", Time.at(time_before(days)), Time.at(time_before(days) + 300)
    ).all.map do |row|
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

  def time_before(number_days)
    Time.now.to_i - 86400 * number_days
  end
end
