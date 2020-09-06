/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { ADD_CONTACTS } from '@constants/contacts';

export var addContacts = contacts => ({
  type: ADD_CONTACTS,
  contacts
});
