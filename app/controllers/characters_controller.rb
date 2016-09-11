class CharactersController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create, :update]

  def new
    @character = BuildCharacter.new.build(campaign: Campaign.vanilla_fate_core)
    @campaign  = Campaign.vanilla_fate_core
  end

  def create
    @character = current_user.characters.build character_params
    @campaign  = Campaign.vanilla_fate_core

    if @character.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @character = Character.find(params[:id])
    @campaign  = Campaign.vanilla_fate_core
  end

  def update
    @character = Character.find params[:id]

    if @character.update_attributes character_params
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
    @character = Character.find params[:id]
  end

  private

  def character_params
    params.require(:character).permit([
      :name, :description, :refresh, :user_id, :campaign_id,
      ratings_attributes: [:id, :skill_id, :level],
      aspects_attributes: [:id, :name, :aspectable_id, :aspectable_type, :_destroy],
      stunts_attributes: [:id, :name, :description, :_destroy],
      extras_attributes: [:id, :name, :description, :_destroy],
      stress_tracks_attributes: [:id, :name, :skill_id, :_destroy,
        stress_levels_attributes: [:id, :level, :checked, :_destroy]
      ],
      consequences_attributes: [:id, :level, :name, :description, :skill_id, :skill_level_to_unlock, :_destroy]
    ])
  end

  def fae_campaign
  end

end
