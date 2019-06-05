class Destination < ApplicationRecord
  geocoded_by :name
  has_many :favorites, dependent: :destroy
  has_many :steps, dependent: :destroy
end
