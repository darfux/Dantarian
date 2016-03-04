unless defined? Rails
  require './sniffer'
end

module Fux
  class ISBNSniffer < Sniffer
    def self.sniff_jd(item_id)
      uri = URI("http://item.jd.com/#{item_id}.html")
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(update_encoding(res.body, 'GBK'))
      isbn = html_doc.css('#product-detail-1 li')[1]['title']
    end
  end
end