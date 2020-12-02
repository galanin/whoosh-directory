import { combineReducers } from 'redux';
import { connectRouter } from 'connected-react-router';

import session from '@reducers/session';
import nodes from '@reducers/nodes';
import units from '@reducers/units';
import people from '@reducers/people';
import employments from '@reducers/employments';
import contacts from '@reducers/contacts';
import current from '@reducers/current';
import initial_state from '@reducers/initial_state';
import layout from '@reducers/layout';
import search from '@reducers/search';
import search_cache from '@reducers/search_cache';
import birthdays from '@reducers/birthdays';
import birthday_period from '@reducers/birthday_period';
import to_call from '@reducers/to_call';
import favorites from '@reducers/favorites';
import settings from '@reducers/settings';
import menu from '@reducers/menu';

export default history =>
  combineReducers({
    session,
    nodes,
    units,
    current,
    people,
    employments,
    contacts,
    initial_state,
    layout,
    search,
    search_cache,
    birthdays,
    birthday_period,
    to_call,
    favorites,
    menu,
    settings,
    router: connectRouter(history)
  });
