class SamplePdf < Prawn::Document

  def initialize(sample)
    super(page_size: "A4")
    @sample = sample
    @hazards = Hazard.find(:all)
    @stores = Store.find(:all)
    @sensitivities = Sensitivity.find(:all)
    header
    sample_code
    details
    coshh
    structure
#
# New sample receipt dispenses with tear-off slip
# bar code and redundant coshh information. JPH 12/09/2014
#
#    scissor_line
#    show_barcode
#    coshh_summary
      
  end

  def header
    nbsp = Prawn::Text::NBSP
      text "Newcastle Crystallography Service", font: "Helvetica", size: 20, style: :bold, align: :center
      text "Bedson Building#{nbsp}#{nbsp} " + 
           "<font name='ZapfDingbats' size='8'>F#{nbsp}#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}Newcastle University#{nbsp}#{nbsp}" + 
           "<font name='ZapfDingbats' size='8'>#{nbsp}#{nbsp}F#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}NE1 7RU", size: 10, 
             align: :center, :inline_format => true

    move_down 10
    stroke do
      horizontal_rule
    end
  end

# Old sample code routine. JPH 12/09/2014.
#
#  def sample_code
#    text_box "Sample Code: #{@sample.code}", size: 16, style: :bold, align: :left, :at => [0,bounds.top-84]
#    move_up 16
#    text_box "Your Ref: #{@sample.userref}", size: 16, style: :bold, align: :right, :at => [250,bounds.top-84]
#    intro_str = "Please check the details on this receipt. " +
#                "Changes can be made only by Crystallography staff. " +
#                "Please use the tear-off slip at the bottom of the page and " +
#                "attach it to your sample. You will be automatically " +
#                "informed via e-mail of any changes to your sample status."
#    text_box intro_str, size: 10, size: 10, :at => [0,bounds.top-104]
#  end

  def sample_code
    text_box "Sample Code: #{@sample.code}", size: 16, style: :bold, align: :left, :at => [0,bounds.top-74]
    move_up 16
    text_box "Your Ref: #{@sample.userref}", size: 16, style: :bold, align: :right, :at => [250,bounds.top-74]
    intro_str = "Please check the details on this receipt. " +
                "Changes can be made only by Crystallography staff. " +
                "Please print this receipt and submit it along with " +
                "your sample. Make sure you label your sample with the " +
                "sample code generated. You will be automatically " +
                "informed via e-mail of any changes to your sample status."
    text_box intro_str, size: 10, size: 10, :at => [0,bounds.top-94]
  end

  def show_barcode

    require 'tempfile'
    require 'barby'
    require 'barby/barcode/code_39'
    require 'barby/outputter/png_outputter'
    #require 'barby/outputter/ascii_outputter'

    barcode = Barby::Code39.new(@sample.barcode)

    # puts barcode.to_ascii #Implicitly uses the AsciiOutputter

    pagewidth = bounds.right - bounds.left
    bounding_box([0,108], :width => pagewidth) do

      font("Courier" ) do
        font_size 8
        str = "#{@sample.code}(#{@sample.userref})"
        text_box str, :at => [5,cursor+10], :width => 155, :height => 24,
                      :style => :bold, :align => :center,
                      :overflow => :shrink_to_fit
#        draw_text "#{@sample.code}(#{@sample.userref})", size: 12, style: :bold, :at => [0,cursor+3]
      end

      temp_file = Tempfile.new(['bc', '.png'])

      temp_file.write barcode.to_png(:margin => 0)
      temp_file.close

      image temp_file.path

      temp_file.close(true)

      bc_str = @sample.barcode.gsub(/(.{1})(?=.)/, '\1 \2')
    

      font("Courier" ) do
        draw_text "#{bc_str}", size: 12, style: :bold, :at => [7,cursor-10]
      end
    end

  end

  def scissor_line
    vmiddle=(bounds.top + bounds.bottom)*0.5
    hmiddle=(bounds.left + bounds.right)*0.5
    pagewidth = bounds.right - bounds.left
    bounding_box([0,154], :width => pagewidth) do
      dash(5, :space => 5, :phase => 3)
      stroke do
        pad(20) {
          font("ZapfDingbats", :size => 28) do
            draw_text "$", :at => [hmiddle,cursor]
          end
          move_up 10
          horizontal_rule
        }
      end
      undash
    end
  end

  def structure

    pagewidth = bounds.right - bounds.left
    boxwidth = 524
    boxheight = 0.7*boxwidth  -50
  # 
  # This next bit gives the absolute path name of the structure image
  #
    strucfile = Rails.root.to_s + '/public' + @sample.synth_url.to_s
    tmp_str = `identify -format "%[fx:w]x%[fx:h]" "#{strucfile}"`
    img_dim = tmp_str.split('x')
    img_ratio = 1.0*img_dim[0].to_i/img_dim[1].to_i
    
  #
    text_box "Proposed Structure with Numbering Scheme and Synthetic Route Details", size: 12, style: :bold, align: :left, :at => [0,bounds.top-455]
    bounding_box([0,bounds.top-469], :width => boxwidth, :height => boxheight) do
      bounding_box([22,bounds.top-3], :width => 416, :height => 312) do
      if (img_ratio >= 1.33333) then
        image strucfile, :position => :center, :vposition => :center, :width => 416
      else
        image strucfile, :position => :center, :vposition => :center, :height => 312
      end
      end
    stroke_bounds
    end

  end

  def details

    pagewidth = bounds.right - bounds.left
    boxwidth = pagewidth*0.5 - 5
    boxheight = 0.75*boxwidth

    text_box "Sample Details and Requirements", size: 12, style: :bold, align: :left, :at => [0,bounds.top-148]

    bounding_box([0 ,bounds.top-162], :width => boxwidth, :height => boxheight*0.6-22) do
      bounding_box([5 ,bounds.top-5], :width => boxwidth-10, :height => boxheight-10) do
        text "<b>Chemical Formula:</b> #{@sample.cif}", :size => 10, :inline_format => true
        text "<b>Powder Diffraction Required?</b> #{@sample.powd ? 'Yes' : 'No'}", :size => 10, :inline_format => true
        text "<b>Chiral Structure?</b> #{@sample.chiral ? 'Yes' : 'No'}", :size => 10, :inline_format => true
        text "<b>Your Priority Number:</b> #{@sample.priority}", :size => 10, :inline_format => true
      end
      stroke_bounds
    end
    text_box "User Details", size: 12, style: :bold, align: :left, :at => [boxwidth+10,bounds.top-148]
    bounding_box([boxwidth+10 ,bounds.top-162], :width => boxwidth, :height => boxheight*0.6 -22) do
      bounding_box([5 ,bounds.top-5], :width => boxwidth-10, :height => boxheight-10) do
        text "<b>Submission Date:</b> #{@sample.created_at}", :size => 10, :inline_format => true
        text "<b>Submitted By:</b> #{@sample.user.firstname} #{@sample.user.lastname}", :size => 10, :inline_format => true
        text "<b>Research Group:</b>  #{@sample.user.group.group_desc}", :size => 10, :inline_format => true
        text "<b>Contact E-Mail:</b>  #{@sample.user.email}", :size => 10, :inline_format => true
        text "<b>Cost Centre Code:</b> #{@sample.cost_code}", :size => 10, :inline_format => true
        text "<b>Assigned Bar Code:</b> #{@sample.barcode}", :size => 10, :inline_format => true
      end
      stroke_bounds
    end

  end

  def coshh
    text_box "Supplied COSHH Information", size: 12, style: :bold, align: :left, :at => [0,498]
    bounding_box([0,485], :width => 524, :height => 150) do
      boxwidth = bounds.right - bounds.left
      boxheight = bounds.top - bounds.bottom
      stroke_bounds

      font_size = 8
      box1_posx = boxwidth*0.5+5
      box1_posy = bounds.top-10
      box1_wid  = (boxwidth*0.5-20)/3
      box1_hgt  = boxheight-20

      box2_posx = box1_posx + box1_wid + 5
      box2_posy = box1_posy
      box2_wid  = box1_wid
      box2_hgt  = box1_hgt

      box3_posx = box2_posx + box1_wid + 5
      box3_posy = box1_posy
      box3_wid  = box1_wid
      box3_hgt  = box1_hgt

      fill_color "eeeeee"
      fill_rectangle [box1_posx ,box1_posy+5], box1_wid, box1_hgt+10
      fill_rectangle [box2_posx ,box2_posy+5], box2_wid, box2_hgt+10
      fill_rectangle [box3_posx ,box3_posy+5], box3_wid, box3_hgt+10
      fill_color "000000"

      bounding_box([bounds.left+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Name of Solvent:</b>  #{@sample.coshh_name}", :size => 10, :inline_format => true
        text "<b>Description of Expected Product:</b>  #{@sample.coshh_desc}", :size => 10, :inline_format => true
        text "<b>Handling Procedures:</b>  #{@sample.coshh_info}", :size => 10, :inline_format => true
        text "<b>User Comments:</b>  #{@sample.comments}", :size => 10, :inline_format => true
      end

      bounding_box([box1_posx+5 ,box1_posy-5], :width => box1_wid-10, :height => box1_hgt-10) do
        text "<b>Hazards:</b>", :size => font_size, :inline_format => true
        move_down 10
        if (@sample.hazards.count > 5)
          font_size = 6
        end
        if (@sample.hazards.count < 6)
          font_size = 8
        end
        for hazard in @hazards
          if @sample.hazards.include? hazard
            str = "#{hazard.hazard_desc} (#{hazard.hazard_abbr})"
            text str, :size => font_size, :inline_format => true
          end
        end
      end

      bounding_box([box2_posx+5 ,box2_posy-5], :width => box2_wid-10, :height => box2_hgt-10) do
        text "<b>Storage:</b>", :size => font_size, :inline_format => true
        move_down 6
        if (@sample.stores.count > 5)
          font_size = 6
        end
        if (@sample.stores.count < 6)
          font_size = 8
        end
        for store in @stores
          if @sample.stores.include? store
            str = store.name
            text str, :size => font_size, :inline_format => true
          end
        end
      end

      bounding_box([box3_posx+5 ,box3_posy-5], :width => box3_wid-10, :height => box3_hgt-10) do
        text "<b>Sensitivity:</b>", :size => font_size, :inline_format => true
        move_down 6
        if (@sample.sensitivities.count > 5)
          font_size = 6
        end
        if (@sample.sensitivities.count < 6)
          font_size = 8
        end
        for sense in @sensitivities
          if @sample.sensitivities.include? sense
            str = sense.name
            text str, :size => font_size, :inline_format => true
          end
        end
      end

    end


  end

  def coshh_summary
  
    font_size = 6
    if (@sample.coshh_info)
      if (@sample.coshh_info.split(/\s+/).size +
        @sample.comments.split(/\s+/).size > 30)
        font_size = 5
      end
    end


    text_box "Supplied COSHH Information", size: 8, style: :bold, align: :left, :at => [195,118]
    bounding_box([195,108], :width => 330, :height => 100) do
      boxwidth = bounds.right - bounds.left
      boxheight = bounds.top - bounds.bottom
      stroke_bounds
      bounding_box([bounds.left+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Name of Solvent:</b>  #{@sample.coshh_name}", :size => font_size, :inline_format => true
        text "<b>Description of Sample:</b>  #{@sample.coshh_desc}", :size => font_size, :inline_format => true
        text "<b>Handling Procedures:</b>  #{@sample.coshh_info}", :size => font_size, :inline_format => true
        text "<b>User Comments:</b>  #{@sample.comments}", :size => font_size, :inline_format => true
      end
      font_size = 6
      box1_posx = boxwidth*0.5+5
      box1_posy = bounds.top-10
      box1_wid  = (boxwidth*0.5-20)/3
      box1_hgt  = boxheight-20

      box2_posx = box1_posx + box1_wid + 5
      box2_posy = box1_posy
      box2_wid  = box1_wid
      box2_hgt  = box1_hgt
    
      box3_posx = box2_posx + box1_wid + 5
      box3_posy = box1_posy
      box3_wid  = box1_wid
      box3_hgt  = box1_hgt

      fill_color "eeeeee"
      fill_rectangle [box1_posx ,box1_posy+2], box1_wid, box1_hgt+4
      fill_rectangle [box2_posx ,box2_posy+2], box2_wid, box2_hgt+4
      fill_rectangle [box3_posx ,box3_posy+2], box3_wid, box3_hgt+4
      fill_color "000000"

      bounding_box([box1_posx+2 ,box1_posy-2], :width => box1_wid-4, :height => box1_hgt-4) do
        text "<b>Hazards:</b>", :size => font_size, :inline_format => true
        move_down 6
        if (@sample.hazards.count > 5)
          font_size = 5
        end
        if (@sample.hazards.count < 6)
          font_size = 6
        end
        for hazard in @hazards
          if @sample.hazards.include? hazard
            str = "#{hazard.hazard_desc} (#{hazard.hazard_abbr})"
            text str, :size => font_size, :inline_format => true
          end
        end
      end

      bounding_box([box2_posx+2 ,box2_posy-2], :width => box2_wid-4, :height => box2_hgt-4) do
        text "<b>Storage:</b>", :size => font_size, :inline_format => true
        move_down 6
        if (@sample.stores.count > 5)
          font_size = 5
        end
        if (@sample.stores.count < 6)
          font_size = 6
        end
        for store in @stores
          if @sample.stores.include? store
            str = store.name
            text str, :size => font_size, :inline_format => true
          end
        end
      end

      bounding_box([box3_posx+2 ,box3_posy-2], :width => box3_wid-4, :height => box3_hgt-4) do
        text "<b>Sensitivity:</b>", :size => font_size, :inline_format => true
        move_down 6
        if (@sample.sensitivities.count > 5)
          font_size = 5
        end
        if (@sample.sensitivities.count < 6)
          font_size = 6
        end
        for sense in @sensitivities
          if @sample.sensitivities.include? sense
            str = sense.name
            text str, :size => font_size, :inline_format => true
          end
        end
      end


    end

    font_size = 6

    font("Helvetica") do
      draw_text "School of Chemistry Crystallography Service, Newcastle University", :size => font_size, :at => [195,0], :style => :italic
    end

  end
end
