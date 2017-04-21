class PagesController < ApplicationController
  def dashboard
    @project_count = Project.count
    @open_source_count = Project.where(open_source: Project::OPEN_SOURCE).count
    @open_source_percentage = @project_count == 0 ? 0 : 100 * @open_source_count / @project_count.to_f
    @closed_source_count = @project_count - @open_source_count
    @closed_source_percentage = @project_count == 0 ? 0 : 100 * @closed_source_count / @project_count.to_f
    @gov_reuse_count = Project.where(government_wide_reuse: Project::GOVERNMENT_WIDE_REUSE).count
    @gov_reuse_percentage = @project_count == 0 ? 0 : 100 * @gov_reuse_count / @project_count.to_f
    @non_gov_reuse_count = @project_count - @gov_reuse_count
    @non_gov_reuse_percentage = @project_count == 0 ? 0 : 100 * @non_gov_reuse_count / @project_count.to_f
  end

  def help
  end
end
