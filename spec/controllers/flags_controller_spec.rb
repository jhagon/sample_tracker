require File.dirname(__FILE__) + '/../spec_helper'

describe FlagsController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Flag.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Flag.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Flag.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(flag_url(assigns[:flag]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Flag.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Flag.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Flag.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Flag.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Flag.first
    response.should redirect_to(flag_url(assigns[:flag]))
  end

  it "destroy action should destroy model and redirect to index action" do
    flag = Flag.first
    delete :destroy, :id => flag
    response.should redirect_to(flags_url)
    Flag.exists?(flag.id).should be_false
  end
end
