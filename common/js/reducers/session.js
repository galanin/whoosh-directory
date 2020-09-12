import { SET_SESSION_TOKEN } from '@constants/session';

export default (state, action) => {
  if (state == null) {
    state = {};
  }
  switch (action.type) {
    case SET_SESSION_TOKEN:
      return { token: action.token };

    default:
      return state;
  }
};
