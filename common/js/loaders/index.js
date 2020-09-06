/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import init from '@loaders/init';
import birthdays from '@loaders/birthdays';
import employments from '@loaders/employments';
import search from '@loaders/search';
import nodes from '@loaders/nodes';

export default (function(store) {
  init(store);
  birthdays(store);
  employments(store);
  search(store);
  return nodes(store);
});
