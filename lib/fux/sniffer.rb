unless defined? Rails
	require 'net/http'
	require 'nokogiri'
	require 'json'
end

module Fux
  class Sniffer
    def self.update_encoding(str, src_encoding)
      str.force_encoding(src_encoding)
      str.encode!('utf-8', src_encoding, {:invalid => :replace, :undef => :replace})
    end
  end
end