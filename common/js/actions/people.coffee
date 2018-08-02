import { ADD_PEOPLE } from '@constants/people'

export addPeople = (people) ->
  type: ADD_PEOPLE
  people: people
