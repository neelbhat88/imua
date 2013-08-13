class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :teacher_only

  def index

  end
end
