require "whatlanguage/string"

class Suggestor
  def initialize(args)
    @twitter_client = args.fetch(:twitter_client)
    @repository     = args.fetch(:repository)
  end

  def users_to_follow(number)
    (suggestions - followers_now - following_now - following_by_twitterise - yourself).sample(60).select { |user_id|
      valid_suggestion(user_id)
    }.sample(number)
  end

  def users_to_unfollow(days)
    following_by_twitterise_after(days)
  end

  def users_to_reset
    following_now & following_by_twitterise
  end

  private

  attr_reader :twitter_client, :repository

  def suggestions
    following_now.sample(2).inject([]) { |candidates, user|
      candidates << twitter_client.followers(user)
    }.flatten.uniq
  end

  def following_now
    @following_now ||= twitter_client.following
  end

  def followers_now
    @followers_now ||= twitter_client.followers
  end

  def following_by_twitterise_after(days)
    repository.following_after(days)
  end

  def following_by_twitterise
    repository.following
  end

  def yourself
    [twitter_client.user.id]
  end

  def valid_suggestion(user_id)
    user = twitter_client.user(user_id)
    !user.protected? && languages.include?(user.description.language)
  end

  def languages
    if ENV["LANGUAGES"]
      ENV["LANGUAGES"].split(",").map(&:to_sym)
    else
      [:english]
    end
  end
end
