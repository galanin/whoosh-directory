/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import {
  POP_LAYOUT_BLOCK,
  SINK_LAYOUT_BLOCK,
  LAYOUT_BLOCK_STRUCTURE,
  LAYOUT_BLOCK_NODE_INFO,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_RECENT,
  LAYOUT_BLOCK_TO_CALL
} from '@constants/layout';

export var popNodeInfo = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_NODE_INFO
});

export var popEmployeeInfo = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO
});

export var sinkEmployeeInfo = () => ({
  type: SINK_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO
});

export var popSearchResults = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_SEARCH_RESULTS
});

export var popStructure = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_STRUCTURE
});

export var popFavorites = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_FAVORITES
});

export var popRecent = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_RECENT
});

export var popToCall = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_TO_CALL
});
