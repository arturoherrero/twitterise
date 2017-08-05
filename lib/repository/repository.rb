require_relative "../persistence/sqlite_adaptor"

class Repository
  def initialize(args = {})
    @database = args.fetch(:db) { SQLiteAdaptor.database }
  end

  def save_following(user_id)
    following_table.insert(
      user_id:    user_id,
      created_at: Time.now,
    )
  end

  def following_after(days)
    following_table.where(Sequel[:created_at] < Time.at(time_before(days))).map(:user_id)
  end

  def following
    following_table.map(:user_id)
  end

  private

  attr_reader :database

  def following_table
    database[:following]
  end

  def time_before(number_days)
    Time.now.to_i - 86400 * number_days + 300
  end
end
