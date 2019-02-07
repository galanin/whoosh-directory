import { without, clone, sortBy } from 'lodash'

import {
  LOADED_FAVORITES
  ADDING_FAVORITE_EMPLOYMENT
  ADDING_FAVORITE_UNIT
  REMOVING_FAVORITE_EMPLOYMENT
  REMOVING_FAVORITE_UNIT
  CHANGED_FAVORITE_EMPLOYMENTS
  CHANGED_FAVORITE_UNITS
  SHOW_FAVORITE_EMPLOYMENTS
  SHOW_FAVORITE_UNITS
} from '@constants/favorites'


default_state =
  employment_ids: []
  unit_ids: []
  show: 'employments'

export default (state = default_state, action) ->
  switch action.type
    when LOADED_FAVORITES
      employment_ids : action.employment_ids
      unit_ids       : action.unit_ids
      show           : state.show

    when ADDING_FAVORITE_EMPLOYMENT
      state

    when ADDING_FAVORITE_UNIT
      state

    when REMOVING_FAVORITE_EMPLOYMENT
      new_state = Object.assign({}, state)
      new_state.employment_ids = without(state.employment_ids, action.employment_id)
      new_state

    when REMOVING_FAVORITE_UNIT
      new_state = Object.assign({}, state)
      new_state.unit_ids = without(state.unit_ids, action.unit_id)
      new_state

    when CHANGED_FAVORITE_EMPLOYMENTS
      new_state = Object.assign({}, state)
      new_state.employment_ids = action.employment_ids
      new_state

    when CHANGED_FAVORITE_UNITS
      new_state = Object.assign({}, state)
      new_state.unit_ids = action.unit_ids
      new_state

    when SHOW_FAVORITE_EMPLOYMENTS
      new_state = Object.assign({}, state)
      new_state.show = 'employments'
      new_state

    when SHOW_FAVORITE_UNITS
      new_state = Object.assign({}, state)
      new_state.show = 'units'
      new_state

    else
      state
