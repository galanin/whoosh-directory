/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { UserRequest } from '@lib/request';

import {
  SET_SETTINGS,
  SET_SETTING
} from '@constants/settings';


export var loadSettings = () => (dispatch, getState) => UserRequest.get(getState, 'settings').then(response => dispatch(setSettings(response.body.settings))

  , function(error) {});


export var saveSetting = (key, value) => (function(dispatch, getState) {
  dispatch(setSetting(key, value));
  return UserRequest.put(getState, 'settings', {key, value}).then(function(response) {});
});


export var setSettings = settings => ({
  type: SET_SETTINGS,
  settings
});


export var setSetting = (key, value) => ({
  type: SET_SETTING,
  key,
  value
});
