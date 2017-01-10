class Relationship < ApplicationRecord
  belongs_to :user_one, class_name: User.name
  belongs_to :user_two, class_name: User.name
end
