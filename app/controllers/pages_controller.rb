class PagesController < ApplicationController
  def dashboard
    @project_count = Project.count
    @open_source_count = Project.where(open_source: true).count
    @government_wide_reuse_count = Project.where(government_wide_reuse: true).count
  end

  def help
  end
end
