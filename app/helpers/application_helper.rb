module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:search => params[:search], :sort => column, :direction => direction}, {:class => css_class}
  end

  def neat_time(date)
    date.strftime("%d/%m/%Y") + date.strftime("(%I:%M%P)")
  end

  def create_menu
    @pages = Page.find_all_by_menu(true)
      ulist = ''
    if (@pages)
      ulist = '<ul>'
      for page in @pages
        url = "/#{page.permalink}"
        ulist = ulist + "<li>#{link_to page.permalink, url}</li>"
      end
      ulist = ulist + '</ul>'
      ulist
    end  
  end


end
