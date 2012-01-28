require File.dirname(__FILE__) + '/../spec_helper'

describe StoresController do
  fixtures :all
  render_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Store.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Store.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Store.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(store_url(assigns[:store]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Store.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Store.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Store.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Store.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Store.first
    response.should redirect_to(store_url(assigns[:store]))
  end

  it "destroy action should destroy model and redirect to index action" do
    store = Store.first
    delete :destroy, :id => store
    response.should redirect_to(stores_url)
    Store.exists?(store.id).should be_false
  end
end
