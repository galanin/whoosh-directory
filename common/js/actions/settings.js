import { UserRequest } from '@lib/request';

import { SET_SETTINGS, SET_SETTING } from '@constants/settings';

export const loadSettings = () => (dispatch, getState) =>
  UserRequest.get(getState, 'settings').then(
    response => dispatch(setSettings(response.body.settings)),

    error => {}
  );

export const saveSetting = (key, value) => (dispatch, getState) => {
  dispatch(setSetting(key, value));
  return UserRequest.put(getState, 'settings', {
    key,
    value
  }).then(response => {});
};

export const setSettings = settings => ({
  type: SET_SETTINGS,
  settings
});

export const setSetting = (key, value) => ({
  type: SET_SETTING,
  key,
  value
});
