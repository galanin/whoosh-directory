/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { ADD_CONTACTS } from '@constants/contacts';

export default (function(state, action) {
  if (state == null) { state = {}; }
  switch (action.type) {
    case ADD_CONTACTS:
      var new_contacts = Object.assign({}, state);
      action.contacts.forEach(contact => new_contacts[contact.id] = contact);
      return new_contacts;

    default:
      return state;
  }
});
