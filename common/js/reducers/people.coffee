import { ADD_PEOPLE } from '@constants/people'

export default (state = {}, action) ->
  switch action.type
    when ADD_PEOPLE
      new_people = Object.assign({}, state)
      action.people.forEach (person) ->
        new_people[person.id] = person
      new_people

    else
      state
