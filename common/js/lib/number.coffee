import { padStart } from 'lodash'


export padNumber = (number, length = 2) ->
  number_str = number.toString()
  padStart(number_str, length, '0')

