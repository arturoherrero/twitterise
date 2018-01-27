require_relative "../persistence/sqlite_adaptor"

class Repository
  SECOND = 1
  MINUTE = 60 * SECOND
  HOUR = 60 * MINUTE
  DAY = 24 * HOUR

  def initialize(args = {})
    @database = args.fetch(:db) { SQLiteAdaptor.database }
  end

  def save_following(user_id)
    following_table.insert(
      user_id:    user_id,
      created_at: Time.now,
      unfollowed: false,
    )
  end

  def following_after(days)
    following_table.where(Sequel[:created_at] < time_before(days)).exclude(:unfollowed)
    .map(:user_id)
  end

  def following
    following_table.map(:user_id)
  end

  def mark_unfollowed(user_id)
    following_table.where(user_id: user_id).update(unfollowed: true)
  end

  private

  attr_reader :database

  def following_table
    database[:following]
  end

  def time_before(number_days)
    Time.now - number_days * DAY + last_execution_duration
  end

  def last_execution_duration
    5 * MINUTE
  end
end
