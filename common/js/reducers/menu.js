/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  OPEN_MENU,
  CLOSE_MENU
} from '@constants/menu';


export default (function(state, action) {
  if (state == null) { state = { open: false }; }
  switch (action.type) {
    case OPEN_MENU:
      return {open: true};

    case CLOSE_MENU:
      return {open: false};

    default:
      return state;
  }
});
