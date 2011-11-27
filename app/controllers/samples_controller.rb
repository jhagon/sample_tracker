class SamplesController < ApplicationController

  before_filter :authenticate_user!

  def make_sample_code
    x = Time.now
    grp = current_user.group.group_abbr
    usr = current_user.firstname.first.upcase +
           current_user.lastname.first.upcase
    yr  = x.strftime('%g')
    num = create_sample_num
    "#{grp}-#{usr}-#{yr}-#{num}"
  end

  def create_sample_num
    x = Time.now
    yr = x.strftime('%g')
    grp = current_user.group.group_abbr
    samps = Sample.where('code LIKE ?', "#{grp}-%-#{yr}-%").all
    if (samps.length > 0)
      str = samps.last.code
      last_num = /\d\d\d\d$/.match(str)[0].to_i
      new_num = last_num + 1
      # now an amazing idiom to convert to 4 digit string!
      return "%04d" % new_num
    else
      return 1
    end
  end


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
    @sample.code = make_sample_code
  end

  def create
    # @sample = Sample.new(params[:sample])
    @sample = current_user.samples.build params[:sample]
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
