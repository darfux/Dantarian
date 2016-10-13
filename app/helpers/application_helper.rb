module ApplicationHelper
  def use_min!
    if Rails.env.production? then '.min' else '' end
  end
end
