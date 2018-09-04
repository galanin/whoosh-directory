import { ADD_EMPLOYMENTS } from '@constants/employments'

export default (state = {}, action) ->
  switch action.type
    when ADD_EMPLOYMENTS
      new_employments = Object.assign({}, state)
      action.employments.forEach (employment) ->
        new_employments[employment.id] = employment
      new_employments

    else
      state
