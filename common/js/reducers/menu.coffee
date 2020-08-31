import {
  OPEN_MENU
  CLOSE_MENU
} from '@constants/menu'


export default (state = { open: false }, action) ->
  switch action.type
    when OPEN_MENU
      open: true

    when CLOSE_MENU
      open: false

    else
      state
