class UsersController < ApplicationController

helper_method :sort_column, :sort_direction

  def show
    @user = current_user
    s = @user.samples
@samples=s.all( :joins => :flag,
                          :order => "#{sort_column} #{sort_direction}")

  end

private

  def sort_column
    cols = Sample.column_names + Flag.column_names
    cols.include?(params[:sort]) ? params[:sort] : "code"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
