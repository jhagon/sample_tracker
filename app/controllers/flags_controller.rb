class FlagsController < ApplicationController
  def index
    @flags = Flag.all
  end

  def show
    @flag = Flag.find(params[:id])
  end

  def new
    @flag = Flag.new
  end

  def create
    @flag = Flag.new(params[:flag])
    if @flag.save
      redirect_to @flag, :notice => "Successfully created flag."
    else
      render :action => 'new'
    end
  end

  def edit
    @flag = Flag.find(params[:id])
  end

  def update
    @flag = Flag.find(params[:id])
    if @flag.update_attributes(params[:flag])
      redirect_to @flag, :notice  => "Successfully updated flag."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @flag = Flag.find(params[:id])
    @flag.destroy
    redirect_to flags_url, :notice => "Successfully destroyed flag."
  end
end
