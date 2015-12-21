module ApplicationHelper
  def full_title(page_title)
    title = 'Ruby on Rails Tutorial Sample App'
    title = "#{page_title} | #{title}" if page_title.present?
    return title
  end
end
