class Csv < ApplicationRecord
  if !Rails.env.production?
    has_attached_file :csv
  else  
    has_attached_file :csv, :storage => :cloudinary
  end
  validates_attachment :csv, content_type: { content_type: "text/csv" }
end
