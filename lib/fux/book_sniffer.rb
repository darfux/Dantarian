require 'socksify/http'
module Fux
  class BookSniffer < Sniffer
    FAILED_LIMIT = 4;
    NONE = 'none'
    def self.sniff(isbn)
      isbn.to_s.gsub!(/[- ]/,'')

      failed_count = 0
      result = {name: '汝尋之書 始皇焚矣', 
        cover: '', author: '', source: NONE}

      begin
        result = sniff_from_douban(isbn)
      rescue => e
        puts e
      end

      result
    end



    def self.sniff_from_douban(isbn)
      book = nil
      if defined? Rails
        book = Rails.cache.read({isbn: isbn})
      end
      unless book
        uri = URI("https://api.douban.com/v2/book/isbn/")
        # res = Net::HTTP.get_response(uri+isbn)
        res = Net::HTTP.SOCKSProxy('127.0.0.1', 1080).get_response(uri+isbn)
        book = JSON.parse(res.body)
        if defined? Rails
          Rails.cache.write({isbn: isbn}, book)
        end
      end
      {isbn: isbn, name: book['title'], cover: book['image'], author: book['author'].join, source: 'db'}
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
      {isbn: isbn, name: name.strip, cover: cover[7..-1], source: 'dd'}
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
      {isbn: isbn, name: name.strip, cover: cover[7..-1], source: 'm_dd'}
    end

    def self.sniff_from_jd(isbn)
      uri = URI('http://search.jd.com/Search')
      params = { keyword: isbn, enc: 'utf-8', wq: isbn}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      html_doc = Nokogiri::HTML(res.body)
      cover = html_doc.css("#J_goodsList").css('.p-img img').first['src']
      name = html_doc.css("#J_goodsList").css('.p-name em').first.children[0].content
      {isbn: isbn, name: name.strip, cover: cover[2..-1], source: 'jd'}
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
      {isbn: isbn, name: name.strip, cover: cover[7..-1], source: 'm_jd'}
    end
  end

end