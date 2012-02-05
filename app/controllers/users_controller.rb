class UsersController < ApplicationController

  helper_method :sort_column, :sort_direction

  before_filter :authenticate_user!
  before_filter :must_be_user_or_admin, :only => [:show, :edit, :update]
  before_filter :admin_required, :only => [:index, :destroy, :become]

  def become
    return unless current_user.admin?
    # sign_in(:user, User.find(params[:id]))
    sign_in User.find(params[:id]), :bypass => true
    redirect_to root_url # or user_root_url
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end


  def show
    @user = User.find(params[:id])
    @samples=Sample.page(params[:page]).per_page(ITEMS_PER_PAGE).where("(user_id = '#{current_user.id}') AND (code LIKE '%#{params[:search]}%')").joins(:flag, {:user => :group}).order("#{sort_column} #{sort_direction}")

  end

  def test_blank_pw

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
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
