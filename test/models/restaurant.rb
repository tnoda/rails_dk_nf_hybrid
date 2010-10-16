class Restaurant < ActiveRecord::Base
  belongs_to :city
  additional_foreign_key :city, :foreign_key => :city_name
  belongs_to :cuisine
  additional_foreign_key :cuisine, :foreign_key => :cuisine_name
end
