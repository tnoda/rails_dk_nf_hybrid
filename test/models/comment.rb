class Comment < ActiveRecord::Base
  belongs_to :person
  additional_foreign_key :person, :foreign_key => :person_name, :secondary_key => :name
end
