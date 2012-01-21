class GroupsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_filter :admin_required, :only => [:index, :create, :new, 
                                           :edit, :update, :destroy]
  before_filter :must_be_leader_or_admin, :only => :show

  def index
    @groups = Group.all
  end


  def show
    @group = Group.find(params[:id])
    @samples=@group.samples.page(params[:page]).per_page(ITEMS_PER_PAGE).all( :joins => :flag,
    :order => "#{sort_column} #{sort_direction}")
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      redirect_to @group, :notice => "Successfully created group."
    else
      render :action => 'new'
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update_attributes(params[:group])
      redirect_to @group, :notice  => "Successfully updated group."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_url, :notice => "Successfully destroyed group."
  end

private

  def must_be_leader_or_admin
    @group = Group.find(params[:id])
    return true if (user_signed_in? and (current_user.admin? or (current_user.leader? and current_user.group == @group)))
    session[:return_to] = request.request_uri
    redirect_to root_url,
             :alert =>
             "You must be a leader for this group or an administrator to view group data!" and return false
  end

  def sort_column
    cols = Sample.column_names + Flag.column_names
    cols.include?(params[:sort]) ? params[:sort] : "code"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
