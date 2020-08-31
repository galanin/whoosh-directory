import { UserRequest } from '@lib/request'

import {
  SET_SETTINGS
  SET_SETTING
} from '@constants/settings'


export loadSettings = ->
  (dispatch, getState) ->
    UserRequest.get(getState, 'settings').then (response) ->
      dispatch(setSettings(response.body.settings))

    , (error) ->


export saveSetting = (key, value) ->
  (dispatch, getState) ->
    dispatch(setSetting(key, value))
    UserRequest.put(getState, 'settings', key: key, value: value).then (response) ->


export setSettings = (settings) ->
  type: SET_SETTINGS
  settings: settings


export setSetting = (key, value) ->
  type: SET_SETTING
  key: key
  value: value
