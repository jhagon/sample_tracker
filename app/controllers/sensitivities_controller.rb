class SensitivitiesController < ApplicationController
  def index
    @sensitivities = Sensitivity.all
  end

  def show
    @sensitivity = Sensitivity.find(params[:id])
  end

  def new
    @sensitivity = Sensitivity.new
  end

  def create
    @sensitivity = Sensitivity.new(params[:sensitivity])
    if @sensitivity.save
      redirect_to @sensitivity, :notice => "Successfully created sensitivity."
    else
      render :action => 'new'
    end
  end

  def edit
    @sensitivity = Sensitivity.find(params[:id])
  end

  def update
    @sensitivity = Sensitivity.find(params[:id])
    if @sensitivity.update_attributes(params[:sensitivity])
      redirect_to @sensitivity, :notice  => "Successfully updated sensitivity."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @sensitivity = Sensitivity.find(params[:id])
    @sensitivity.destroy
    redirect_to sensitivities_url, :notice => "Successfully destroyed sensitivity."
  end
end
