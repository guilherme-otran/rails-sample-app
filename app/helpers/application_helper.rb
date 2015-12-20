module ApplicationHelper
  def full_title(page_title)
    title = 'Ruby on Rails Tutorial Sample App'
    title = "#{title} | #{page_title}" if page_title
    return title
  end
end
