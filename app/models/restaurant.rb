class Restaurant < ActiveRecord::Base

	has_many :reviews, dependent: :destroy

	validates :name, length: {minimum:1}, uniqueness: true

end
