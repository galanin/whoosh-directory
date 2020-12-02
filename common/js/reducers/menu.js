import { OPEN_MENU, CLOSE_MENU } from '@constants/menu';

export default (state, action) => {
  if (!state) {
    state = { open: false };
  }
  switch (action.type) {
    case OPEN_MENU:
      return { open: true };

    case CLOSE_MENU:
      return { open: false };

    default:
      return state;
  }
};
