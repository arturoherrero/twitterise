require "logger"
require "twitter"

class TwitterClient
  def initialize
    @logger = Logger.new(STDOUT)
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
  end

  # Returns extended user information
  # If not username is specified, refers to the implicit authenticated user.
  def user(username = nil)
    twitter_request do
      logger.info "Get user information of #{username || 'me'}"
      client.user(username)
    end
  end

  # Returns an array of numeric IDs
  # If not user_id is specified, refers to the implicit authenticated user.
  def following(user_id = nil)
    twitter_request do
      logger.info "Get following of #{user_id || 'me'}"
      client.friend_ids(user_id).take(5000)
    end
  end

  # Returns an array of numeric IDs
  # If not user_id is specified, refers to the implicit authenticated user.
  def followers(user_id = nil)
    twitter_request do
      logger.info "Get followers of #{user_id || 'me'}"
      client.follower_ids(user_id).take(5000)
    end
  end

  def follow(user_id)
    twitter_request do
      logger.info "Follow #{user_id}"
      client.follow(user_id)
      mute(user_id) if muting
    end
  end

  def unfollow(user_id)
    twitter_request do
      logger.info "Unfollow #{user_id}"
      client.unfollow(user_id)
      unmute(user_id) if muting
    end
  end

  private

  attr_reader :logger, :client

  def twitter_request(&block)
    block.call
  rescue Twitter::Error::Forbidden, Twitter::Error::NotFound => e
    logger.error e.message
  rescue Twitter::Error::RequestTimeout => e
    logger.error e.message
    retry
  rescue Twitter::Error::TooManyRequests => e
    logger.error e.message
    logger.error "Limit: #{e.rate_limit.limit}"
    exit
  end

  def mute(user_id)
    twitter_request do
      logger.info "Mute #{user_id}"
      client.mute(user_id)
    end
  end

  def unmute(user_id)
    twitter_request do
      logger.info "Unmute #{user_id}"
      client.unmute(user_id)
    end
  end

  def muting
    case ENV["MUTE"] || "false"
    when /^true$/  then true
    when /^false$/ then false
    else raise StandardError, "Error casting string to boolean"
    end
  end
end
