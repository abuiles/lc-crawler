require 'rss'
require 'open-uri'
require 'json'
require 'parameterize'

url = ARGV[0]

def extract_episodes_data(url)
  open(url) do |rss|
    # http://ruby-doc.org/stdlib-2.2.3/libdoc/rss/rdoc/RSS/Parser.html
    feed = RSS::Parser.parse(rss, false, true)

    feed.channel.items.first(1).map do |episode|
      {
        title: episode.title,
        pubDate: episode.pubDate,
        description: episode.description,
        summary: episode.description,
        itunesSubtitle: episode.itunes_subtitle,
        itunesKeywords: episode.itunes_keywords,
        enclosure: {
          url: episode.enclosure.url,
          type: episode.enclosure.type
        },
        itunesDuration: {
          content: episode.itunes_duration.content,
          hour: episode.itunes_duration.hour,
          minute: episode.itunes_duration.minute,
          second: episode.itunes_duration.second
        },
        itunesExplicit: episode.itunes_explicit,
        podcastId: feed.channel.title.parameterize,
        guid: {
          isPermaLink: feed.channel.items.first.guid.isPermaLink,
          content: feed.channel.items.first.guid.content
        }
      }
    end
  end
end


puts JSON.pretty_generate(extract_episodes_data(url))
