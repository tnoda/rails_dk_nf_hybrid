class Comment < ActiveRecord::Base
  belongs_to :person
  additional_foreign_key :person, :foreign_key => :person_name, :referenced_foreign_key => :name
end
