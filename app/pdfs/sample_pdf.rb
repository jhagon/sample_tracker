class SamplePdf < Prawn::Document
  
  def initialize(sample)
    super(page_size: "A4")
    @sample = sample
    @hazards = Hazard.find(:all)
    header
    structure
    sample_code
    coshh
    scissor_line
    show_barcode
    coshh_summary
      
  end

  def header
    nbsp = Prawn::Text::NBSP
      text "Newcastle Crystallography Service", font: "Helvetica", size: 30, style: :bold, align: :center
      text "Bedson Building#{nbsp}#{nbsp} " + 
           "<font name='ZapfDingbats' size='12'>F#{nbsp}#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}Newcastle University#{nbsp}#{nbsp}" + 
           "<font name='ZapfDingbats' size='12'>#{nbsp}#{nbsp}F#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}NE1 7RU", size: 16, 
             align: :center, :inline_format => true

    move_down 10
    stroke do
      horizontal_rule
    end
  end

  def sample_code
    text_box "Sample Code: #{@sample.code}", size: 16, style: :bold, align: :left, :at => [0,bounds.top-84]
    move_up 16
    text_box "Your Ref: #{@sample.userref}", size: 16, style: :bold, align: :right, :at => [400,bounds.top-84]
    intro_str = "Please check the details on this receipt. " +
                "Changes can be made only by Crystallography staff." +
                "Please use the tear-off slip at the bottom of the page and " +
                "attach it to your sample. You will be automatically " +
                "informed via e-mail of any changes to your sample status."
    text_box intro_str, size: 10, size: 10, :at => [0,bounds.top-104]
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
        draw_text "#{@sample.code}", size: 14, style: :bold, :at => [32,cursor+3]
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
    bounding_box([0,144], :width => pagewidth) do
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
    boxwidth = pagewidth*0.5 - 5
    boxheight = 0.75*boxwidth
  # 
  # This next bit gives the absolute path name of the structure image
  #
    strucfile = Rails.root.to_s + '/public' + @sample.synth_url.to_s
  #
    text_box "Proposed Structure and Synthetic Route", size: 12, style: :bold, align: :left, :at => [0,bounds.top-168]
    text_box "Sample Details and Requirements", size: 12, style: :bold, align: :left, :at => [boxwidth+10,bounds.top-168]

    bounding_box([0,bounds.top-182], :width => boxwidth, :height => boxheight) do
      image strucfile, :position => :center, :height => boxheight*0.9, :width => boxwidth*0.9
    stroke_bounds
    end
    bounding_box([boxwidth+10 ,bounds.top-182], :width => boxwidth, :height => boxheight*0.25-5) do
      bounding_box([5 ,bounds.top-5], :width => boxwidth-10, :height => boxheight-10) do
        text "<b>Powder Diffraction Required?</b> #{@sample.powd ? 'Yes' : 'No'}", :size => 10, :inline_format => true
        text "<b>Chiral Structure?</b> #{@sample.chiral ? 'Yes' : 'No'}", :size => 10, :inline_format => true
        text "<b>Your Priority Number:</b> #{@sample.priority}", :size => 10, :inline_format => true
      end
      stroke_bounds
    end
    text_box "User Details", size: 12, style: :bold, align: :left, :at => [boxwidth+10,bounds.top-248]
    bounding_box([boxwidth+10 ,bounds.top-262], :width => boxwidth, :height => boxheight*0.7 -22) do
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
    text_box "Supplied COSHH Information", size: 12, style: :bold, align: :left, :at => [0,386]
    bounding_box([0,372], :width => 524, :height => 180) do
      boxwidth = bounds.right - bounds.left
      boxheight = bounds.top - bounds.bottom
      stroke_bounds
      bounding_box([bounds.left+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Name of Solvent:</b>  #{@sample.coshh_name}", :size => 10, :inline_format => true
        text "<b>Description of Sample:</b>  #{@sample.coshh_desc}", :size => 10, :inline_format => true
        text "<b>Hazards and Procedures:</b>  #{@sample.coshh_info}", :size => 10, :inline_format => true
      end
      bounding_box([boxwidth*0.5+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Hazard Categories:</b>", :size => 10, :inline_format => true
        move_down 12
        for hazard in @hazards
          if @sample.hazards.include? hazard
            str = "#{hazard.hazard_desc} (#{hazard.hazard_abbr})"
            text str, :size => 10, :inline_format => true
          end
        end 

      end
    end


  end

  def coshh_summary

    text_box "Supplied COSHH Information", size: 8, style: :bold, align: :left, :at => [195,118]
    bounding_box([195,108], :width => 330, :height => 100) do
      boxwidth = bounds.right - bounds.left
      boxheight = bounds.top - bounds.bottom
      stroke_bounds
      bounding_box([bounds.left+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Name of Solvent:</b>  #{@sample.coshh_name}", :size => 8, :inline_format => true
        text "<b>Description of Sample:</b>  #{@sample.coshh_desc}", :size => 8, :inline_format => true
        text "<b>Hazards and Procedures:</b>  #{@sample.coshh_info}", :size => 8, :inline_format => true
      end
      bounding_box([boxwidth*0.5+10 ,bounds.top-10], :width => boxwidth*0.5-20, :height => boxheight-20) do
        text "<b>Hazard Categories:</b>", :size => 8, :inline_format => true
        move_down 12
        for hazard in @hazards
          if @sample.hazards.include? hazard
            str = "#{hazard.hazard_desc} (#{hazard.hazard_abbr})"
            text str, :size => 8, :inline_format => true
          end
        end
      end
      indent(5) do
        text "<i>School of Chemistry Crystallography Service, Newcastle University</i>", :size => 8, :inline_format => true
      end
    end
  end


end
