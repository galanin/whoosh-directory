import { each, filter, split, startsWith } from 'lodash';

const url_parsing_cache = {};

const surePathParsed = pathname => {
  if (!url_parsing_cache[pathname]) {
    const location_arr = split(pathname, '/');
    const params_hash = {};
    each(location_arr, part => {
      let matches;
      // eslint-disable-next-line no-useless-escape
      if ((matches = part.match(/^([^\-]+)-(.+)$/))) {
        return (params_hash[matches[1]] = matches[2]);
      }
    });

    url_parsing_cache[pathname] = params_hash;
  }

  return url_parsing_cache[pathname];
};

export const getNewUrlParam = (payload, param_name) => {
  const path_params = surePathParsed(payload.location.pathname);
  return path_params[param_name];
};
