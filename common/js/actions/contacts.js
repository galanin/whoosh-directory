import { ADD_CONTACTS } from '@constants/contacts';

export const addContacts = contacts => ({
  type: ADD_CONTACTS,
  contacts
});
