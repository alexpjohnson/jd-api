# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  domain     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Organization < ActiveRecord::Base
  resourcify

  has_many :user_organizations
  has_many :users, through: :user_organizations
  has_many :tag_types
  has_many :tag_type_groups
  has_many :projects
  has_one :org_setting

  validates_uniqueness_of :domain, allow_nil: true, allow_blank: true

  after_create :set_up_org

  private

  def set_up_org
    jess = User.find_by!(email: 'jessrrobins@gmail.com')
    OrgSetting.create!(organization: self)
    Project.create_default_project(
      org_id: id,
      created_by_id: jess.id
    )
  end
end
