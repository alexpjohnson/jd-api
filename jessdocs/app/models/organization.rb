# organization
# name          string
# domain        string
# created_at    datetime
# updated_at    datetime

class Organization < ActiveRecord::Base
    has_many :user_organizations
    has_many :users, through: :user_organizations
    has_many :tag_types
    has_many :tag_type_groups
    has_many :projects
    
    validates_uniqueness_of :domain, allow_nil: true, allow_blank: true
end