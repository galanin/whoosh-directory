import {
  OPEN_MENU
  CLOSE_MENU
} from '@constants/menu'


export openMenu = ->
  type: OPEN_MENU


export closeMenu = ->
  type: CLOSE_MENU
