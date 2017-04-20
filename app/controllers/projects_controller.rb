class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:tags).order(:name)
  end
end
