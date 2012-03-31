module SamplesHelper

  def popup_info( ref_str )
    if (p = Popup.find_by_name( ref_str ))
      p.description
    end
  end

  def samples_per_page_select(collection = Sample)
    select_tag :per_page, options_for_select([ITEMS_PER_PAGE,2,3,4,5,10,15,20,25,30,40,50,["\u{221E}", 1000000]],
    collection.per_page)
  end


end
