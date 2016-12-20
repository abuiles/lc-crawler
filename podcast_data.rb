require 'rss'
require 'open-uri'
require 'json'
require 'parameterize'

url = ARGV[0]

def extract_podcast_data(url)
  open(url) do |rss|
    # http://ruby-doc.org/stdlib-2.2.3/libdoc/rss/rdoc/RSS/Parser.html
    feed = RSS::Parser.parse(rss, false, true)

    {
      id: feed.channel.title.parameterize,
      title: feed.channel.title,
      link:  feed.channel.link,
      description: feed.channel.description,
      itunesCategories: feed.channel.itunes_categories.map(&:text),
      itunesImage: feed.channel.itunes_image.href,
      copyright: feed.channel.copyright,
      itunesAuthor: feed.channel.itunes_author,
      itunesSubtitle: feed.channel.itunes_subtitle,
      itunesOwner: {},
    }.tap do |hsh|
      if feed.channel.itunes_owner
        hsh[:itunesOwner] = {
          itunesName: feed.channel.itunes_owner.itunes_name,
          itunesEmail: feed.channel.itunes_owner.itunes_email
        }
      end
    end
  end
end

puts JSON.pretty_generate(extract_podcast_data(url))
