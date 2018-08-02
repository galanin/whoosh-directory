import { ADD_EMPLOYMENTS } from '@constants/employments'

export addEmployments = (employments) ->
  type: ADD_EMPLOYMENTS
  employments: employments
