
class StressTrack {
  constructor(el) {
    this.el = el;
    this.skillId = el.querySelector('.stress-track-fields__skill-id');
    this.addStressLevelBtn = el.querySelector('.add_fields');
    this.lastStressLevel = el.querySelectorAll('.form__stress-box').length;

    $(el).on('cocoon:before-insert', this.updateAddedStressLevel.bind(this));
    $(el).on('cocoon:before-remove', this.updateRemovedStressLevel.bind(this));

    this.adjustStressLevels(skillLevel);
  }

  adjustStressLevels(skillLevel) {
    if (this.stressLevelBySkillLevel(skillLevel) === this.lastStressLevel) {
      return;
    }

    if (this.stressLevelBySkillLevel(skillLevel) > this.lastStressLevel) {
      this.addStressLevel();
      this.adjustStressLevels(skillLevel);
    } else {
      this.removeStressLevel();
      this.adjustStressLevels(skillLevel);
    }
  }

  stressLevelBySkillLevel(skillLevel) {
    switch (skillLevel) {
      case 0:
        return 2;
      case 1:
      case 2:
        return 3;
      default:
        return 4;
    }
  }

  removeStressLevel() {
    const stressLevels = this.el.querySelectorAll('.form__stress-box--valid');

    this.dispatchClick(stressLevels[stressLevels.length - 1].querySelector('.remove_fields'));
  }

  addStressLevel() {
    this.dispatchClick(this.addStressLevelBtn);
  }

  dispatchClick(el) {
    $(el).trigger('click');
  }

  updateAddedStressLevel(ev, added) {
    this.lastStressLevel += 1;

    added[0].querySelector('.stress-box__checked-label').textContent = this.lastStressLevel;
    added[0].querySelector('.stress-box__level').value = this.lastStressLevel;
  }

  updateRemovedStressLevel(ev, removed) {
    this.lastStressLevel -= 1;

    removed[0].classList.remove('form__stress-box--valid');
  }
}

export default StressTrack;
