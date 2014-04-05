class Campaign < ActiveRecord::Base
  has_many :characters
  has_many :stress_tracks, as: :stressable, dependent: :destroy
  has_many :consequences, as: :consequential, dependent: :destroy
  belongs_to :skill_type
  belongs_to :skill_group
  belongs_to :user

  accepts_nested_attributes_for :stress_tracks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :consequences, allow_destroy: true, reject_if: :all_blank

  def self.vanilla_fate_core
    campaign = self.new
    campaign.number_of_aspects = 5
    campaign.number_of_phases = 3
    campaign.refresh_rate = 3
    campaign.number_of_initial_stunts = 3
    campaign.number_of_stress_boxes = 3

    stress_tracks = [
      {name: 'mental', skill_id: 18},
      { name: 'physical', skill_id: 12}
    ]

    stress_tracks.reverse.each do |skill|
      campaign.stress_tracks.build(name: skill[:name], skill_id: skill[:skill_id]) do |stress_track|
        [1, 2, 3, 4].each do |level|
          stress_track.stress_levels.build level: level
        end
      end
    end

    consequences = [
      {name: 'mild', level: 2},
      {name: 'moderate', level: 4},
      {name: 'severe', level: 6},
      {name: 'mild', level: 2, skill_id: 12, skill_level_to_unlock: 5},
    ]

    consequences.each do |consequence|
      campaign.consequences.build consequence
    end

    campaign
  end
end
