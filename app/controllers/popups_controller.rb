class PopupsController < ApplicationController

  before_filter :admin_required

  def index
    @popups = Popup.all
  end

  def show
    @popup = Popup.find(params[:id])
  end

  def new
    @popup = Popup.new
  end

  def create
    @popup = Popup.new(params[:popup])
    if @popup.save
      redirect_to @popup, :notice => "Successfully created popup."
    else
      render :action => 'new'
    end
  end

  def edit
    @popup = Popup.find(params[:id])
  end

  def update
    @popup = Popup.find(params[:id])
    if @popup.update_attributes(params[:popup])
      redirect_to @popup, :notice  => "Successfully updated popup."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @popup = Popup.find(params[:id])
    @popup.destroy
    redirect_to popups_url, :notice => "Successfully destroyed popup."
  end
end
