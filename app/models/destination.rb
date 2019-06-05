class Destination < ApplicationRecord
  geocoded_by :name
  has_many :favorites, dependent: :destroy
  has_many :steps, dependent: :destroy

  def description_extract
    if description.length >= 175
      description[0..175] + " ..."
    else
      description
    end
  end
end
