# Twitterise

Two objectives:

1. Have a **new and diverse timeline over the time**. We always follow people
similar to us, let's start with new ideas from different people. **By default
Twitterise follows 5 new people for 5 days**. These numbers are not completely
random because we need to deal with the [Twitter API rate limits][1], but
it can definitely be much more aggressive.

2. **Increase the number of followers is a by product** but following people sometimes
they will follow you back. Again, remember the Twitter following rules and best
practices or maybe one day you are going to wonder [why can't I follow people?][2]

**Twitterise never follows the same user twice.**


## Instalation

    $ bundle install

You need to create a new [Twitter App][3] with read and write permissions to work
with the Twitter API. Also it's necessary to create a `.env` file with the
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

In order to automate the use of Twitterise is a good idea to run once per day.
To achieve this, insert a new line in crontab, e.g. every day at 10:00 AM:

    $ crontab -e

    0 10 * * * bin/twitterise

Everything is a messy, you want to enjoy your Twitter account like in the
beginning, no problem:

    $ bin/reset


## Statics

You can track the number of followers with [Twitter Analytics][4], under the
Followers section.

![Twitter Analytics][5]


[1]: https://dev.twitter.com/rest/public/rate-limiting
[2]: https://support.twitter.com/articles/66885-i-can-t-follow-people-follow-limits
[3]: https://apps.twitter.com/
[4]: https://ads.twitter.com/
[5]: /twitter-followers.png
