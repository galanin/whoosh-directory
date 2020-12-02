import { invert, map, isEqual } from 'lodash';

import {
  LAYOUT_BLOCK_STRUCTURE,
  LAYOUT_BLOCK_NODE_INFO,
  LAYOUT_BLOCK_EMPLOYEE_INFO,
  LAYOUT_BLOCK_SEARCH_RESULTS,
  LAYOUT_BLOCK_FAVORITES,
  LAYOUT_BLOCK_RECENT,
  LAYOUT_BLOCK_TO_CALL,
  DEFAULT_LAYOUT,
  ONE_COLUMN_MAX,
  TWO_COLUMN_MIN,
  TWO_COLUMN_MAX,
  THREE_COLUMN_MIN,
  THREE_COLUMN_MAX,
  FOUR_COLUMN_MIN
} from '@constants/layout';

const BLOCK_IDS = {
  s: LAYOUT_BLOCK_STRUCTURE,
  n: LAYOUT_BLOCK_NODE_INFO,
  e: LAYOUT_BLOCK_EMPLOYEE_INFO,
  r: LAYOUT_BLOCK_SEARCH_RESULTS,
  f: LAYOUT_BLOCK_FAVORITES,
  t: LAYOUT_BLOCK_RECENT,
  c: LAYOUT_BLOCK_TO_CALL
};

const BLOCK_CODES = invert(BLOCK_IDS);

export const isDefaultLayout = layout => isEqual(layout, DEFAULT_LAYOUT);

export const packLayout = layout_ids =>
  map(layout_ids, layout_id => BLOCK_CODES[layout_id]).join('');

export const unpackLayout = layout_codes =>
  map(layout_codes, layout_code => BLOCK_IDS[layout_code]);

export const isOneColumn = () => window.innerWidth <= ONE_COLUMN_MAX;

export const isTwoColumn = () =>
  TWO_COLUMN_MIN <= window.innerWidth && window.innerWidth <= TWO_COLUMN_MAX;

export const isThreeColumn = () =>
  THREE_COLUMN_MIN <= window.innerWidth &&
  window.innerWidth <= THREE_COLUMN_MAX;

export const isFourColumn = () => FOUR_COLUMN_MIN <= window.innerWidth;
