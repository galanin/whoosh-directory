import { ADD_CONTACTS } from '@constants/contacts';

export default (function(state, action) {
  if (!state) {
    state = {};
  }
  switch (action.type) {
    case ADD_CONTACTS:
      var new_contacts = Object.assign({}, state);
      action.contacts.forEach(contact => (new_contacts[contact.id] = contact));
      return new_contacts;

    default:
      return state;
  }
});
