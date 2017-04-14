require "uri"

class Project < ApplicationRecord
  OPEN_SOURCE = 1
  CLOSED_SOURCE = 0
  GOVERNMENT_WIDE_REUSE = 1
  NOT_GOVERNMENT_WIDE_REUSE = 0

  has_and_belongs_to_many :tags
  belongs_to :source

  validates :name, presence: true
  validates :description, presence: true
  validates :repository, presence: true, format: URI::regexp(%w(http https)), allow_nil: true
  validate :repository_required_if_open_source
  validates :license, presence: true, format: URI::regexp(%w(http https)), allow_nil: true
  validates :open_source, presence: true, inclusion: { in: [OPEN_SOURCE, CLOSED_SOURCE] }
  validates :government_wide_reuse, presence: true, inclusion: { in: [GOVERNMENT_WIDE_REUSE, NOT_GOVERNMENT_WIDE_REUSE] }
  validates :contact_email, presence: true, format: /.+@.+\..+/i
  validates :source, presence: true
  validates :source_identifier, presence: true

  def repository_required_if_open_source
    if !repository.present? && open_source == OPEN_SOURCE
      errors.add(:repository, "required if project is open source")
    end
  end

  def update_from_metadata(metadata)
    self.name = metadata["name"]
    self.description = metadata["description"]
    self.repository = metadata["repository"]
    self.license = metadata["license"]
    self.open_source = metadata["openSourceProject"]
    self.government_wide_reuse = metadata["governmentWideReuseProject"]
    self.contact_email = metadata.dig("contact", "email")
    self.organization = metadata["organization"]
    new_tags = []
    metadata["tags"].each do |tag_name|
      new_tags << Tag.find_or_create_by(name: tag_name)
    end
    self.tags = new_tags
  end

  def self.new_from_metadata(metadata, metadata_source, source_identifier)
    Project.new do |p|
      p.update_from_metadata(metadata)
      p.source = metadata_source
      p.source_identifier = source_identifier
    end
  end
end
