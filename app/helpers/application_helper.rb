module ApplicationHelper
  def use_min!
    if Rails.env.production? then '.min' else '' end
  end

  def scanner_url
  	remote_host = "http://dantarian.applinzi.com/"
  	if Rails.env.production?
  		"#{remote_host}?target=dantarian.darfux.cc/books/new_by_isbn/"
  	else
  		"#{remote_host}?target=test.darfux.cc:3000/books/new_by_isbn/"
  	end
  end
end
