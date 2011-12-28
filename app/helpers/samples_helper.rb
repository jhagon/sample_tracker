module SamplesHelper

  def popup_info( ref_str )
    if (p = Popup.find_by_name( ref_str ))
      p.description
    end
  end

end
