class Destination < ApplicationRecord
  geocoded_by :name
  has_many :favorites
end
