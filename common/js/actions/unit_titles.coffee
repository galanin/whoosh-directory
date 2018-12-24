import { ADD_UNIT_TITLES } from '@constants/unit_titles'


export addUnitTitles = (unit_titles) ->
  type: ADD_UNIT_TITLES
  unit_titles: unit_titles
