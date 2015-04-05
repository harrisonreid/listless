class List < ActiveRecord::Base
	has_many :memberships
  has_many :users, through: :memberships
  validates :name, presence: true, length: { maximum: 200 }
end
