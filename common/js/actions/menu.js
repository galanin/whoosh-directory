/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  OPEN_MENU,
  CLOSE_MENU
} from '@constants/menu';


export var openMenu = () => ({
  type: OPEN_MENU
});


export var closeMenu = () => ({
  type: CLOSE_MENU
});
