/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import search from '@automation/search';
import url from '@automation/url';

export default (function(store) {
  search(store);
  return url(store);
});
