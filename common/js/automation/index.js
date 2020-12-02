import search from '@automation/search';
import url from '@automation/url';

export default store => {
  search(store);
  return url(store);
};
