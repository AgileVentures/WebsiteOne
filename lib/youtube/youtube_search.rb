require 'rexml/document'
require 'cgi'
require 'open-uri'

module YoutubeSearch
  class << self

    def user_videos(user_id)
      xml = open("http://gdata.youtube.com/feeds/api/users/#{user_id}/uploads?v=2").read
      parse(xml)
    end

    def parse(xml, options={})
      elements_in(xml, 'feed/entry').map do |element|
        entry = xml_to_hash(element)
        entry['video_id'] = if options[:type] == :playlist
                              element.elements['*/yt:videoid'].text
                            else
                              entry['id'].split('/').last
                            end

        #duration = element.elements['*/yt:duration']
        #entry['duration'] = duration.attributes['seconds'] if duration
        #
        #no_embed = element.elements['yt:noembed'] || element.elements['yt:private']
        #entry['embeddable'] = !(no_embed)

        #entry['raw'] = element

        entry
      end
    end

    private

    def elements_in(xml, selector)
      entries = []
      doc = REXML::Document.new(xml)
      doc.elements.each(selector) do |element|
        entries << element
      end
      entries
    end

    def xml_to_hash(element)
      Hash[element.children.map do |child|
        [child.name, child.text]
      end]
    end
  end
end
