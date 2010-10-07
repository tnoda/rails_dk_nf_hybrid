require 'test_helper'
require 'models/author'
require 'models/book'
require 'models/person'
require 'models/comment'
require 'models/member'
require 'models/membership'

class RailsDkNfHybridTest < ActiveSupport::TestCase
  test "raise exception for invalid association_id" do
    assert_raise(RuntimeError) do
      class Foo < ActiveRecord::Base
        belongs_to :author
        additional_foreign_key :invalid_associtation_id, :foregin_key => :author_name
      end
    end
  end

  test "raise exception for unsupported association macro" do
    assert_raise(RuntimeError) do
      class Bar < ActiveRecord::Base
        has_many :author
        additional_foreign_key :author, :foreign_key => :author_name
      end
    end
  end

  test "natural key" do
    a = Author.create!(:author_name => 'Alice')
    b = a.books.create!
    assert a.author_name == b.author_name
  end

  test "secondary key" do
    p = Person.create(:name => 'Baal')
    c = p.comments.create!
    assert p.name == c.person_name
  end

  test "composite key" do
    m = Member.create!(:user_code => 'alpha', :group_code => 'omega')
    ms = m.memberships.create!
    assert m.user_code == ms.user_code && m.group_code == ms.group_code
  end
end
