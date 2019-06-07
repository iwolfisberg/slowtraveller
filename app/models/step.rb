class Step < ApplicationRecord
  belongs_to :user
  belongs_to :destination

  def description_extract
    if description.length >= 120
      description[0..120] + " ..."
    else
      description
    end
  end
end
