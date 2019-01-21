import { loadCurrentBirthdays } from '@actions/birthdays'


prev_day_offset_left = prev_day_offset_right = undefined

export default (store) ->
  store.subscribe ->
    state = store.getState()

    day_offset_left = state.birthday_period?.day_offset_left
    day_offset_right = state.birthday_period?.day_offset_right

    if day_offset_left != prev_day_offset_left or day_offset_right != prev_day_offset_right
      prev_day_offset_left = day_offset_left
      prev_day_offset_right = day_offset_right

      if day_offset_left? and day_offset_right?
        store.dispatch(loadCurrentBirthdays())
