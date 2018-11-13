import {
  ONE_COLUMN_MAX,
  TWO_COLUMN_MIN
  TWO_COLUMN_MAX
  THREE_COLUMN_MIN
  THREE_COLUMN_MAX
  FOUR_COLUMN_MIN
} from '@constants/layout'


export isOneColumn = ->
  window.innerWidth <= ONE_COLUMN_MAX


export isTwoColumn = ->
  TWO_COLUMN_MIN <= window.innerWidth <= TWO_COLUMN_MAX


export isThreeColumn = ->
  THREE_COLUMN_MIN <= window.innerWidth <= THREE_COLUMN_MAX


export isFourColumn = ->
  FOUR_COLUMN_MIN <= window.innerWidth

