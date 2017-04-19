class MetadataHarvesterStatus
  attr_accessor :project, :metadata, :repository, :new_project, :valid
  alias_method :new_project?, :new_project
  alias_method :valid?, :valid
end
