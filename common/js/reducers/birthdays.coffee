import { SET_BIRTHDAY_RESULTS } from '@constants/birthdays'

export default (state = {}, action) ->
  switch action.type
    when SET_BIRTHDAY_RESULTS
      new_birthdays = Object.assign({}, state)
      action.birthdays.forEach (birthday) ->
        new_birthdays[birthday.birthday] = birthday
      new_birthdays

    else
      state
