require 'net/http'
require 'nokogiri'
require 'json'

module Fux
  class BookSniffer
    def self.sniff(isbn)
      isbn.gsub!(/[- ]/,'')

      coin = rand(11)

      case coin
      when 0..3
        sniff_from_m_dangdang(isbn)
      when 4..7
        sniff_from_m_jd(isbn)
      when 8..9
        sniff_from_dangdang(isbn)
      when 10
        sniff_from_jd(isbn)
      end   
    end

    def self.update_encoding(str, src_encoding)
      str.force_encoding(src_encoding)
      str.encode!('utf-8', src_encoding, {:invalid => :replace, :undef => :replace})
    end

    def self.sniff_from_dangdang(isbn)
      uri = URI('http://search.dangdang.com/')
      params = { key: isbn, act: 'input'}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(update_encoding(res.body, 'GB2312'))
      line = html_doc.css(".line1")
      cover = line.css('img').first['src']
      name = line.css('.name a').first['title']
      {name: name.strip, cover: cover[7..-1], src: 'dd'}
    end

    def self.sniff_from_m_dangdang(isbn)
      uri = URI('http://search.m.dangdang.com/search.php')
      params = { keyword: isbn }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(res.body)
      p_left = html_doc.css(".p_left")
      cover = p_left.css('a img').first['data-original']
      name = p_left.css('.name').first.content
      {name: name.strip, cover: cover[7..-1], src: 'm_dd'}
    end

    def self.sniff_from_jd(isbn)
      uri = URI('http://search.jd.com/Search')
      params = { keyword: isbn, enc: 'utf-8', wq: isbn}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(res.body)
      cover = html_doc.css("#J_goodsList").css('.p-img img').first['src']
      name = html_doc.css("#J_goodsList").css('.p-name em').first.children[0].content
      {name: name.strip, cover: cover[2..-1], src: 'jd'}
    end

    def self.sniff_from_m_jd(isbn)
      uri = URI('http://m.jd.com/ware/searchList.action')
      params = { _format_: :json, keyword: isbn, page: 1 }
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)

      res.body[9] = ""
      res.body[-2] = ""
      res.body.gsub!('\"', '"')
      hash = JSON.parse(res.body)["value"]

      first = hash["wareList"][0]
      cover = first["longImgUrl"]
      name = first["wname"]
      {name: name.strip, cover: cover[7..-1], src: 'm_jd'}
    end
  end
end