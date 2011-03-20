require 'spec_helper'

describe TasksController do
  describe "GET new" do
    log_in_as :admin

    it "denies access to non-admins" do
      current_user.stub :admin? => false
      get :new
      response.should deny_access
    end

    it "assigns a new task to @task" do
      Task.stub :new => 'task'
      get :new
      assigns(:task).should == 'task'
    end
  end

  describe "POST create" do
    log_in_as :admin

    let(:task) { Factory.stub(:task) }

    before do
      Task.stub :new => task
      task.stub :save
    end

    it "denies access to non-admins" do
      current_user.stub :admin? => false
      post :create
      response.should deny_access
    end

    it "builds a new task from params[:task]" do
      Task.should_receive(:new).with('attributes')
      post :create, :task => 'attributes'
    end

    it "assigns the new task to @task" do
      post :create
      assigns(:task).should == task
    end

    it "attempts to save the task" do
      task.should_receive(:save)
      post :create
    end

    it "redirects to the task on success" do
      task.stub :save => true
      post :create
      response.should redirect_to(task)
    end

    it "redisplays the form on failure" do
      task.stub :save => false
      post :create
      response.should render_template(:new)
    end
  end

  describe "GET show" do
    it "assigns the task to @task" do
      Task.should_receive(:find).with(42).and_return('task')
      get :show, :id => 42
      assigns(:task).should == 'task'
    end
  end
end
