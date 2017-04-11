require "uri"

class Project < ApplicationRecord
  OPEN_SOURCE = 1
  CLOSED_SOURCE = 0
  GOVERNMENT_WIDE_REUSE = 1
  NOT_GOVERNMENT_WIDE_REUSE = 0

  has_and_belongs_to_many :tags

  validates :name, presence: true
  validates :description, presence: true
  validates :repository, presence: true, format: URI::regexp(%w(http https)), allow_nil: true
  validate :repository_required_if_open_source
  validates :license, presence: true, format: URI::regexp(%w(http https)), allow_nil: true
  validates :open_source, presence: true, inclusion: { in: [OPEN_SOURCE, CLOSED_SOURCE] }
  validates :government_wide_reuse, presence: true, inclusion: { in: [GOVERNMENT_WIDE_REUSE, NOT_GOVERNMENT_WIDE_REUSE] }
  validates :contact_email, presence: true, format: /.+@.+\..+/i

  def repository_required_if_open_source
    if !repository.present? && open_source == OPEN_SOURCE
      errors.add(:repository, "required if project is open source")
    end
  end
end
