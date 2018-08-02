import { ADD_PEOPLE } from '@constants/people'

export default (state = {}, action) ->
  switch action.type
    when ADD_PEOPLE
      Object.assign({}, state, action.people)

    else
      state
