class SamplePdf < Prawn::Document
  
  def initialize(sample)
    super(page_size: "A4")
    @sample = sample
    header
    sample_code
    scissor_line
    show_barcode
      
  end

  def header
    nbsp = Prawn::Text::NBSP
    font("Times-Roman" ) do
      text "Newcastle Crystallography Service", font: "Helvetica", size: 30, style: :bold, align: :center
      text "Bedson Building#{nbsp}#{nbsp} " + 
           "<font name='ZapfDingbats' size='12'>F#{nbsp}#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}Newcastle University#{nbsp}#{nbsp}" + 
           "<font name='ZapfDingbats' size='12'>#{nbsp}#{nbsp}F#{nbsp}#{nbsp}</font>" + 
           "#{nbsp}#{nbsp}NE1 7RU", size: 16, style: :bold, 
             align: :center, :inline_format => true

    end
  end

  def sample_code
    text "Sample #{@sample.code}", size: 24, style: :bold
  end

  def show_barcode

    require 'tempfile'
    require 'barby'
    require 'barby/barcode/code_39'
    require 'barby/outputter/png_outputter'
    #require 'barby/outputter/ascii_outputter'

    barcode = Barby::Code39.new(@sample.barcode)

    # puts barcode.to_ascii #Implicitly uses the AsciiOutputter

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

  def scissor_line
    vmiddle=(bounds.top + bounds.bottom)*0.5
    hmiddle=(bounds.left + bounds.right)*0.5
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
