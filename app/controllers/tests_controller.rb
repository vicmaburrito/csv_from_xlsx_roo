class TestsController < ApplicationController
  def index
    @tests = Test.all
  end

  def import
    Test.import(params[:file])
    redirect_to tests_url
  end
end