import { ADD_CONTACTS } from '@constants/contacts'

export addContacts = (contacts) ->
  type: ADD_CONTACTS
  contacts: contacts
