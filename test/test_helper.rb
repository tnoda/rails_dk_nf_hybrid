require 'rubygems'
require 'test/unit'
require 'active_record'
require 'logger'
require 'rails_dk_nf_hybrid'

ActiveRecord::Base.logger = Logger.new("debug.log")
ActiveRecord::Base.__send__(:include, RailsDkNfHybrid)
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'test.sqlite3')
ActiveRecord::Schema.define do
  create_table :authors, :force => true do |t|
    t.string :author_name
  end

  create_table :books, :force => true do |t|
    t.integer :author_id
    t.string  :author_name
  end

  create_table :people, :force => true do |t|
    t.string :name
  end

  create_table :comments, :force => true do |t|
    t.integer :person_id
    t.string  :person_name
  end

  create_table :members, :force => true do |t|
    t.string :user_code
    t.string :group_code
  end

  create_table :memberships, :force => true do |t|
    t.integer :member_id
    t.string  :user_code
    t.string  :group_code
  end
end
