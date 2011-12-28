class HazardsController < ApplicationController

  before_filter :admin_required

  def index
    @hazards = Hazard.all
  end

  def show
    @hazard = Hazard.find(params[:id])
  end

  def new
    @hazard = Hazard.new
  end

  def create
    @hazard = Hazard.new(params[:hazard])
    if @hazard.save
      redirect_to @hazard, :notice => "Successfully created hazard."
    else
      render :action => 'new'
    end
  end

  def edit
    @hazard = Hazard.find(params[:id])
  end

  def update
    @hazard = Hazard.find(params[:id])
    if @hazard.update_attributes(params[:hazard])
      redirect_to @hazard, :notice  => "Successfully updated hazard."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @hazard = Hazard.find(params[:id])
    @hazard.destroy
    redirect_to hazards_url, :notice => "Successfully destroyed hazard."
  end
end
