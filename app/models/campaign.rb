class Campaign < ActiveRecord::Base
  has_many :characters
  has_many :aspects, as: :aspectable, dependent: :destroy
  has_many :stress_tracks, as: :stressable, dependent: :destroy
  has_many :consequences, as: :consequential, dependent: :destroy
  has_many :skills, through: :skill_group
  has_many :scenes
  belongs_to :skill_type
  belongs_to :skill_group
  belongs_to :user

  accepts_nested_attributes_for :aspects, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stress_tracks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :consequences, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :scenes, allow_destroy: true, reject_if: :all_blank

  validates :number_of_aspects, :number_of_initial_stunts, :refresh_rate, inclusion: { in: 1..15, message: :must_be_between, min: 1, max: 15 }
  validates :skill_cap, inclusion: { in: 1..8, message: :must_be_between, min: 1, max: 8 }
  validates :skill_group, :skill_type, presence: true
  validates :name, presence: true, length: { maximum: 255 }

  validate :does_not_have_characters_associated

  def self.vanilla_fate_core
    campaign = self.new
    campaign.number_of_aspects = 5
    campaign.number_of_phases = 3
    campaign.refresh_rate = 3
    campaign.number_of_initial_stunts = 3
    campaign.number_of_stress_boxes = 3
    campaign.skill_cap = 5
    campaign.skill_group_id = 1

    campaign.skill_type = SkillType.find_by alias: 'pyramid'

    stress_tracks = [
      { name: 'mental', skill_id: 18 },
      { name: 'physical', skill_id: 12 }
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

  private

  def does_not_have_characters_associated
    if persisted? && characters.any?
      errors[:base] << I18n.t("errors.messages.has_characters_associated")
    end
  end
end
