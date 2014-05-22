require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  fixtures :all

  test "should create a project via git-url" do
    post :create, :repo_url => "git@github.com:rrrene/inch.git"
    assert_response :redirect
  end

  test "should rebuild a project" do
    post :rebuild, :service => 'github', :user => 'rrrene', :repo => 'sparkr', :branch => 'master'
    assert_response :redirect
  end


  test "should rebuild a project via web hook" do
    post :rebuild_via_hook, :payload => '{"ref": "refs/heads/master","repository":{"url":"https://github.com/rrrene/sparkr"}}'
    assert_response :success
  end

  # at least not for now
  test "should not create a project via github web-url" do
    post :create, :repo_url => "https://github.com/rrrene/inch"
    assert_response :success
    assert_template :welcome
  end

  test "should not create a project via git-url that doesnot exist on GitHub" do
    post :create, :repo_url => "git@github.com:rrrene/not-here.git"
    assert_response :success
    assert_template :welcome
  end

  test "should not create a project via mumbo-jumbo that doesnot exist on GitHub" do
    post :create, :repo_url => "some mumbo-jumbo"
    assert_response :success
    assert_template :welcome
  end

  test "should get :show" do
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr'
    assert_response :success
  end

  test "should get :show with existing branch" do
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr', :branch => 'master'
    assert_response :success
  end

  test "should get :show with existing revision" do
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr', :branch => 'master', :revision => '8849af2b7ad96c6aa650a6fd5490ef83629faf2a'
    assert_response :success
  end

  test "should get 404 on :show for missing project" do
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr123'
    assert_response :not_found
  end

  test "should get 404 on :show for missing branch" do
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr', :branch => 'master123'
    assert_response :not_found
  end

  test "should get 404 on :show for missing revision" do
    # there is no revision when a project is first created
    # so we can't render 404 when the build is pending
    skip # for now
    get :show, :service => 'github', :user => 'rrrene', :repo => 'sparkr', :branch => 'master', :revision => '123missing'
    assert_response :not_found
  end
end