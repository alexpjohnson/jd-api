# == Schema Information
#
# Table name: tag_type_groups
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#  color           :string
#  organization_id :integer
#  created_by_id   :integer
#

class TagTypeGroup < ActiveRecord::Base
  has_many :tag_types
  belongs_to :organization
  belongs_to :created_by, class_name: 'User'

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :color
  validates_presence_of :organization_id
  validates_uniqueness_of :name, scope: :organization_id

  before_create :downcase

  default_scope { order('lower(name)') }
  scope :for_user, -> (user) { where(created_by: user) }
  scope :for_org, -> (org_id) { where(organization_id: org_id) }

  private

  def downcase
    name.downcase!
  end
end
