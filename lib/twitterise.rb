require_relative "suggestor"
require_relative "twitter_client"
require_relative "../repository/repository"

class Twitterise
  def initialize
    @repository     = Repository.new
    @twitter_client = TwitterClient.new
    @suggestor      = Suggestor.new(
      :repository     => repository,
      :twitter_client => twitter_client,
    )
  end

  def call
    unfollow_old_users
    follow_new_users
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
    4
  end

  def after_days
    5
  end
end
