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

export const popNodeInfo = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_NODE_INFO
});

export const popEmployeeInfo = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO
});

export const sinkEmployeeInfo = () => ({
  type: SINK_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_EMPLOYEE_INFO
});

export const popSearchResults = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_SEARCH_RESULTS
});

export const popStructure = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_STRUCTURE
});

export const popFavorites = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_FAVORITES
});

export const popRecent = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_RECENT
});

export const popToCall = () => ({
  type: POP_LAYOUT_BLOCK,
  layout_block: LAYOUT_BLOCK_TO_CALL
});
