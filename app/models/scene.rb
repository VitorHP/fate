class Scene < ActiveRecord::Base
  has_many :aspects, as: :aspectable
  has_many :stress_tracks, as: :stressable

  belongs_to :campaign

  accepts_nested_attributes_for :aspects, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stress_tracks, allow_destroy: true, reject_if: proc { |at| at['name'].blank? }
end
