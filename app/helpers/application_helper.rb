module ApplicationHelper

  def nice_date(date)
    date.strftime('%b %e, %Y')
  end

end
