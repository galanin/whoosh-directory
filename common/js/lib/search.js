import { invert, map, isEqual } from 'lodash';

import {
  RESULTS_SOURCE_BIRTHDAY,
  RESULTS_SOURCE_QUERY,
  DEFAULT_RESULTS_SOURCE
} from '@constants/search';

const SOURCE_IDS = {
  b: RESULTS_SOURCE_BIRTHDAY,
  q: RESULTS_SOURCE_QUERY
};

const SOURCE_CODES = invert(SOURCE_IDS);

export const isDefaultResultsSource = source =>
  source == null || source === DEFAULT_RESULTS_SOURCE;

export const packResultsSource = source => SOURCE_CODES[source];

export const unpackResultsSource = source_code => SOURCE_IDS[source_code];

export const packQuery = query => encodeURIComponent(query);

export const unpackQuery = query_packed => decodeURIComponent(query_packed);
