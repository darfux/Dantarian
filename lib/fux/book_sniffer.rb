module Fux
  class BookSniffer
    def self.sniff(isbn)
      isbn.gsub!(/[- ]/,'')
      uri = URI('http://search.jd.com/Search')
      params = { keyword: isbn, enc: 'utf-8', wq: isbn}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(res.body)
      cover = html_doc.css("#J_goodsList").css('.p-img img').first['src']
      name = html_doc.css("#J_goodsList").css('.p-name em').first.children[0].content
      {name: name, cover: cover[2..-1]}
    end
  end
end
