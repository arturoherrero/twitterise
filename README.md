# Twitterise 2.0

The objective of the project is to have a **new and diverse timeline**. We
always follow people similar to us, let's start with new ideas from different
people. **By default Twitterise follows 5 new people for 5 days**.

These numbers are not completely random because we need to deal with the
[Twitter API rate limits][1], but it can be much larger. Remember the Twitter
following rules and best practices, and the [technical follow limits][2].

**Twitterise never follows the same user twice.**


## Instalation

    $ bundle install

You need to create a new [Twitter App][3] with read and write permissions to
work with the Twitter API. Also it's necessary to create a `.env` file with the
environment variables needed by the Twitter client.

    export TWITTER_CONSUMER_KEY="YOUR_CONSUMER_KEY"
    export TWITTER_CONSUMER_SECRET="YOUR_CONSUMER_SECRET"
    export TWITTER_ACCESS_TOKEN="YOUR_ACCESS_TOKEN"
    export TWITTER_ACCESS_SECRET="YOUR_ACCESS_SECRET"


## Customization

You can customize the behaviour of Twitterise with some environment variables
that you can add to the `.env` file.

Number of accounts to follow:

    export NUMBER_TO_FOLLOW=10

Number of days to follow an account:

    export FOLLOW_DURING_DAYS=3

Mute the accounts that Twitterise follows:

    export MUTE=true

Language of accounts to follow (based on the Twitter description). Default English.
Available languages: Arabic, Danish, Dutch, English, Farsi, Finnish, French,
German, Greek, Hebrew, Hungarian, Italian, Korean, Norwegian, Pinyin, Polish,
Portuguese, Russian, Spanish, Swedish:

    export LANGUAGES=english,spanish


## Usage

Setup the SQLite database, all the information is self-contained under the `db`
directory:

    $ bin/setup

Run Twitterise:

    $ bin/twitterise

In order to automate the use of Twitterise, it's a good idea to run it once per
day. To achieve this, insert a new line in crontab, e.g. every day at 10:00 AM:

    $ crontab -e

    0 10 * * * export BASH_ENV=/path/to/twitterise/.env; /path/to/ruby /path/to/twitterise/bin/twitterise >> /path/to/twitterise/logs/twitterise.log 2>&1

Everything is a mess, you want to enjoy your Twitter account like at the
beginning, no problem:

    $ bin/reset


## Who made this?

This was made by Arturo Herrero under the MIT License. Find me on Twitter
[@ArturoHerrero][4].


[1]: https://developer.twitter.com/en/docs/rate-limits
[2]: https://help.twitter.com/en/using-twitter/twitter-follow-limit
[3]: https://developer.twitter.com/apps
[4]: https://twitter.com/ArturoHerrero
