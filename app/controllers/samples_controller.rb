class SamplesController < ApplicationController

  def show_barcode

    require 'barby'
    require 'barby/barcode/code_39'
    require 'barby/outputter/png_outputter'
    #require 'barby/outputter/ascii_outputter'
    @sample = Sample.find(params[:id])

    barcode = Barby::Code39.new(@sample.barcode)

    # puts barcode.to_ascii #Implicitly uses the AsciiOutputter

    bcimage = barcode.to_png

    send_data bcimage, :type => 'image/png', :disposition => 'inline'

  end


  def index
    @samples = Sample.all
  end

  def show
    @hazards = Hazard.find(:all)
    @sample = Sample.find(params[:id])
  end

  def new
    @sample = Sample.new
  end

  def create
    @sample = Sample.new(params[:sample])
    if @sample.save
      redirect_to @sample, :notice => "Successfully created sample."
    else
      render :action => 'new'
    end
  end

  def edit
    @hazards = Hazard.find(:all)
    @sample = Sample.find(params[:id])
  end

  def update
    params[:sample][:hazard_ids] ||= []
    @sample = Sample.find(params[:id])
    if @sample.update_attributes(params[:sample])
      redirect_to @sample, :notice  => "Successfully updated sample."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @sample = Sample.find(params[:id])
    @sample.destroy
    redirect_to samples_url, :notice => "Successfully destroyed sample."
  end
end
