import { ADD_EMPLOYMENTS } from '@constants/employments'

export default (state = {}, action) ->
  switch action.type
    when ADD_EMPLOYMENTS
      Object.assign({}, state, action.employments)

    else
      state
