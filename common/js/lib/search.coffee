import { invert, map, isEqual } from 'lodash'


import {
  RESULTS_SOURCE_BIRTHDAY
  RESULTS_SOURCE_QUERY
  DEFAULT_RESULTS_SOURCE
} from '@constants/search'

SOURCE_IDS =
  b: RESULTS_SOURCE_BIRTHDAY
  q: RESULTS_SOURCE_QUERY

SOURCE_CODES = invert(SOURCE_IDS)


export isDefaultResultsSource = (source) ->
  !source? or source == DEFAULT_RESULTS_SOURCE


export packResultsSource = (source) ->
  SOURCE_CODES[source]


export unpackResultsSource = (source_code) ->
  SOURCE_IDS[source_code]


export packQuery = (query) ->
  encodeURIComponent(query)


export unpackQuery = (query_packed) ->
  decodeURIComponent(query_packed)
