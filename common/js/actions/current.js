/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  SET_CURRENT_UNIT_ID,
  SET_HIGHLIGHTED_UNIT_ID,
  SET_CURRENT_EMPLOYMENT_ID,
  SET_CURRENT_CONTACT_ID,
  SCROLL_TO_UNIT,
  SCROLLED_TO_UNIT
} from '@constants/current';

export var setCurrentUnitId = unit_id => ({
  type: SET_CURRENT_UNIT_ID,
  unit_id
});

export var setHighlightedUnitId = unit_id => ({
  type: SET_HIGHLIGHTED_UNIT_ID,
  unit_id
});

export var setCurrentEmploymentId = employment_id => ({
  type: SET_CURRENT_EMPLOYMENT_ID,
  employment_id
});

export var setCurrentContactId = contact_id => ({
  type: SET_CURRENT_CONTACT_ID,
  contact_id
});

export var scrollToUnit = unit_id => ({
  type: SCROLL_TO_UNIT,
  unit_id
});

export var scrolledToUnit = unit_id => ({
  type: SCROLLED_TO_UNIT,
  unit_id
});
