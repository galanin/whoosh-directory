import {
  SET_CURRENT_UNIT_ID,
  SET_HIGHLIGHTED_UNIT_ID,
  SET_CURRENT_EMPLOYMENT_ID,
  SET_CURRENT_CONTACT_ID,
  SCROLL_TO_UNIT,
  SCROLLED_TO_UNIT
} from '@constants/current';

export const setCurrentUnitId = unit_id => ({
  type: SET_CURRENT_UNIT_ID,
  unit_id
});

export const setHighlightedUnitId = unit_id => ({
  type: SET_HIGHLIGHTED_UNIT_ID,
  unit_id
});

export const setCurrentEmploymentId = employment_id => ({
  type: SET_CURRENT_EMPLOYMENT_ID,
  employment_id
});

export const setCurrentContactId = contact_id => ({
  type: SET_CURRENT_CONTACT_ID,
  contact_id
});

export const scrollToUnit = unit_id => ({
  type: SCROLL_TO_UNIT,
  unit_id
});

export const scrolledToUnit = unit_id => ({
  type: SCROLLED_TO_UNIT,
  unit_id
});
