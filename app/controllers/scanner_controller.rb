class ScannerController < ApplicationController
  skip_before_action :authenticate_user!
  def book_record
    if browser.device.mobile?   || 
      browser.platform.android? || 
      browser.platform.ios?
      render 'm_book_record', layout: 'mobile'
    else
      render 'book_record'
    end
  end
end
