class Suggestor
  def initialize(args)
    @twitter_client = args.fetch(:twitter_client)
    @repository     = args.fetch(:repository)
  end

  def users_to_follow(number)
    (suggestions - following_now - following_by_twitterise - yourself).sample(number)
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

  def following_by_twitterise_after(days)
    repository.following_after(days)
  end

  def following_by_twitterise
    repository.following
  end

  def yourself
    [twitter_client.user.id]
  end
end
