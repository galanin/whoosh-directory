import {
  FETCH_INITIAL_STATE_REQUEST,
  FETCH_INITIAL_STATE_SUCCESS,
  FETCH_INITIAL_STATE_FAILURE
} from '@constants/initial_state';

export default (state, action) => {
  if (state == null) {
    state = {};
  }
  switch (action.type) {
    case FETCH_INITIAL_STATE_REQUEST:
      return { fetching: true };
    case FETCH_INITIAL_STATE_SUCCESS:
      return { fetching: false, finished: true, success: true };
    case FETCH_INITIAL_STATE_FAILURE:
      return {
        fetching: false,
        finished: true,
        success: false,
        error: action.error
      };
    default:
      return state;
  }
};
