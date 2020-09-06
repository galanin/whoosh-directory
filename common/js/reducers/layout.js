/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { isEqual } from 'lodash';

import { LOCATION_CHANGE } from 'connected-react-router';
import { getNewUrlParam } from '@lib/url-parsing';
import { URL_PARAM_LAYOUT } from '@constants/url-parsing';

import { unpackLayout } from '@lib/layout';

import {
  DEFAULT_LAYOUT,
  LAYOUT_BLOCK_TO_CALL,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_RECENT,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_STRUCTURE,
  LAYOUT_BLOCK_NODE_INFO,
  POP_LAYOUT_BLOCK,
  SINK_LAYOUT_BLOCK
} from '@constants/layout';

export default (function(state, action) {
  let new_state, new_z_order;
  if (state == null) { state = { pile: DEFAULT_LAYOUT }; }
  switch (action.type) {

    case POP_LAYOUT_BLOCK:
      var new_top_block = action.layout_block;
      if (state.pile[state.pile.length - 1] !== new_top_block) {
        new_z_order = state.pile.filter(block => block !== new_top_block);
        new_z_order.push(new_top_block);
        new_state = Object.assign({}, state);
        new_state.pile = new_z_order;
        return new_state;
      } else {
        return state;
      }

    case SINK_LAYOUT_BLOCK:
      var new_bottom_block = action.layout_block;
      if (state.pile[0] !== new_bottom_block) {
        new_z_order = state.pile.filter(block => block !== new_bottom_block);
        new_z_order.unshift(new_bottom_block);
        new_state = Object.assign({}, state);
        new_state.pile = new_z_order;
        return new_state;
      } else {
        return state;
      }

    case LOCATION_CHANGE:
      if (action.payload.action === 'POP') {
        const layout_packed = getNewUrlParam(action.payload, URL_PARAM_LAYOUT);

        new_state = Object.assign({}, state);

        if (layout_packed != null) {
          const new_layout = unpackLayout(layout_packed);
          if (isEqual(new_layout, state.pile)) {
            state;
          } else {
            new_state.pile = new_layout;
          }
        } else {
          new_state.pile = DEFAULT_LAYOUT;
        }

        return new_state;

      } else {
        return state;
      }

    default:
      return state;
  }
});

