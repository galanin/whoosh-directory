import { loadNodeTree } from '@actions/nodes';
import { loadExpandedNodes } from '@actions/nodes';
import { loadToCall } from '@actions/to_call';
import { loadFavoritePeople, loadFavoriteUnits } from '@actions/favorites';
import { loadSettings } from '@actions/settings';

let initial_info_requested = null;

export default store =>
  store.subscribe(() => {
    if (!initial_info_requested) {
      initial_info_requested = true;

      store.dispatch(loadNodeTree());

      setTimeout(() => store.dispatch(loadExpandedNodes()), 10);

      setTimeout(() => store.dispatch(loadToCall()), 30);
      setTimeout(() => store.dispatch(loadSettings()), 31);
      setTimeout(() => store.dispatch(loadFavoritePeople()), 33);
      return setTimeout(() => store.dispatch(loadFavoriteUnits()), 42);
    }
  });
