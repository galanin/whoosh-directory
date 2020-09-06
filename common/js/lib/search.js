/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
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


export var isDefaultResultsSource = source => (source == null) || (source === DEFAULT_RESULTS_SOURCE);


export var packResultsSource = source => SOURCE_CODES[source];


export var unpackResultsSource = source_code => SOURCE_IDS[source_code];


export var packQuery = query => encodeURIComponent(query);


export var unpackQuery = query_packed => decodeURIComponent(query_packed);
