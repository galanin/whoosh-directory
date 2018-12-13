import { ADD_CONTACTS } from '@constants/contacts'

export default (state = {}, action) ->
  switch action.type
    when ADD_CONTACTS
      new_contacts = Object.assign({}, state)
      action.contacts.forEach (contact) ->
        new_contacts[contact.id] = contact
      new_contacts

    else
      state
