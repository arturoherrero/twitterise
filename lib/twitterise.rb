require_relative "suggestor"
require_relative "twitter_client"
require_relative "repository/repository"

class Twitterise
  def initialize
    @repository     = Repository.new
    @twitter_client = TwitterClient.new
    @suggestor      = Suggestor.new(
      :repository     => repository,
      :twitter_client => twitter_client,
    )
  end

  def run
    unfollow_old_users
    follow_new_users
  end

  def reset
    suggestor.users_to_reset.each do |user_id|
      twitter_client.unfollow(user_id)
    end
  end

  private

  attr_reader :repository, :twitter_client, :suggestor

  def unfollow_old_users
    suggestor.users_to_unfollow(after_days).each do |user_id|
      twitter_client.unfollow(user_id)
    end
  end

  def follow_new_users
    suggestor.users_to_follow(number_to_follow).each do |user_id|
      twitter_client.follow(user_id)
      repository.save_following(user_id)
    end
  end

  def number_to_follow
    (ENV["NUMBER_TO_FOLLOW"] || 5).to_i
  end

  def after_days
    (ENV["FOLLOW_DURING_DAYS"] || 5).to_f
  end
end
