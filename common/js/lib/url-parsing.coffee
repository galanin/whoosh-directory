import { each, filter, split, startsWith } from 'lodash'

url_parsing_cache = {}

surePathParsed = (pathname) ->
  unless url_parsing_cache[pathname]?
    location_arr = split(pathname, '/')
    params_hash = {}
    each location_arr, (part) ->
      if (matches = part.match(/^([^\-]+)-(.+)$/))
        params_hash[matches[1]] = matches[2]

    url_parsing_cache[pathname] = params_hash

  url_parsing_cache[pathname]


export getNewUrlParam = (payload, param_name) ->
  path_params = surePathParsed(payload.location.pathname)
  path_params[param_name]
