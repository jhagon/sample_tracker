class SamplesController < ApplicationController
  helper_method :sort_column, :sort_direction, :join_sql, :join_column_sort

  before_filter :authenticate_user!
  before_filter :must_be_creator_or_admin, :only => :show
  before_filter :admin_required, :only => [:index, :edit, :update, :destroy]

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
    # check if anyone from this group has submitted a sample this year
    # if yes, incr the most recent code number by 1 else return "0001"
    if (samps.length > 0)
      str = samps.last.code
      last_num = /\d\d\d\d$/.match(str)[0].to_i
      new_num = last_num + 1
      # now an amazing idiom to convert to 4 digit string!
      return "%04d" % new_num
    else
      return "%04d" % 1
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
    if (params[:jtable])
      @samples = Sample.joins(join_sql).order(join_column_sort + " " + sort_direction)
    else
      @samples = Sample.order(sort_column + " " + sort_direction)
    end
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

private

  def must_be_creator_or_admin
    sample = Sample.find(params[:id])
    return true if (user_signed_in? and (current_user.admin? or current_user==sample.user))
    session[:return_to] = request.request_uri
    redirect_to root_url,
             :alert =>
             "You must be the sample owner or an administrator to view this sample!" and return false
  end

  def sort_column
    Sample.column_names.include?(params[:sort]) ? params[:sort] : "code"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def join_sql
#  constructs something like  "join flags on samples.flag_id = flags.id"
#
# used multiple equals statements because of strange behaviour
# when adding strings in one expression running over multiple lines.
    join_sql  = "join " + params[:jtable] + " on samples." 
    join_sql += params[:jtable].singularize 
    join_sql += "_id = " + params[:jtable] + ".id"
#
  end

  def join_column_sort
    params[:jtable] + "." + params[:sort]
  end

end
