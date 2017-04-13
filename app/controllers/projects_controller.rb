class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:tags)
  end
end
