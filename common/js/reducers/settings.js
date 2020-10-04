import { SET_SETTINGS, SET_SETTING } from '@constants/settings';

export default (state, action) => {
  if (!state) {
    state = {};
  }
  switch (action.type) {
    case SET_SETTINGS:
      return action.settings;

    case SET_SETTING:
      var new_state = Object.assign({}, state);
      new_state[action.key] = action.value;
      return new_state;

    default:
      return state;
  }
};
