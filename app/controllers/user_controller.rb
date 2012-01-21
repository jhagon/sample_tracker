class UserController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!
  before_filter :must_be_user_or_admin, :only => [:show, :edit, :update]
  before_filter :admin_required, :only => [:index, :destroy]

  load_and_authorize_resource
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created User."
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    s = @user.samples
    @samples=s.page(params[:page]).per_page(ITEMS_PER_PAGE).all( :joins => :flag,
    :order => "#{sort_column} #{sort_direction}")
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated User."
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      redirect_to root_path
    end
  end

private

  def sort_column
    cols = Sample.column_names + Flag.column_names
    cols.include?(params[:sort]) ? params[:sort] : "code"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def must_be_user_or_admin
    user = User.find(params[:id])
    return true if (user_signed_in? and (current_user.admin? or current_user==user))
    session[:return_to] = request.request_uri
    redirect_to root_url,
             :alert =>
             "You must be the relevant user or an administrator to view or edit this user's details!" and return false
  end

end
