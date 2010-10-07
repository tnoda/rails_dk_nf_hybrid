class Book < ActiveRecord::Base
  belongs_to :author
  additional_foreign_key :author, :foreign_key => :author_name
end
