class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:tags).order(:name)
    respond_to do |format|
      format.html
      format.json {
        code_json = {
          "version": "1.0.1",
          "agency": ENV["AGENCY_ACRONYM"],
          "projects": @projects
        }
        render json: code_json
      }
    end
  end
end
