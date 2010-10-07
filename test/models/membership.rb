class Membership < ActiveRecord::Base
  belongs_to :member
  additional_foreign_key :member, :foreign_key => [:user_code, :group_code]
end
