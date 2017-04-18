class PagesController < ApplicationController
  def dashboard
    @project_count = Project.count
    @open_source_count = Project.where(open_source: Project::OPEN_SOURCE).count
    @closed_source_count = @project_count - @open_source_count
    @gov_reuse_count = Project.where(government_wide_reuse: Project::GOVERNMENT_WIDE_REUSE).count
    @non_gov_reuse_count = @project_count - @gov_reuse_count
  end

  def help
  end
end
