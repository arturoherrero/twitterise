class Suggestor
  def initialize(args)
    @twitter    = args.fetch(:twitter_client)
    @repository = args.fetch(:repository)
  end

  def users_to_follow(number)
    (suggestions - following_now - following_by_twitterise).sample(number)
  end

  def users_to_unfollow(days)
    following_by_twitterise_after(days) - following_now
  end

  private

  attr_reader :twitter, :repository

  def suggestions
    following_now.sample(5).inject([]) { |candidates, user|
      candidates << twitter.followers(user)
    }.flatten.uniq
  end

  def following_now
    @following_now ||= twitter.following
  end

  def following_by_twitterise_after(days)
    repository.following_after(days)
  end

  def following_by_twitterise
    repository.following
  end
end
