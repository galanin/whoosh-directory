import search from '@automation/search'
import units from '@automation/units'
import url from '@automation/url'

export default (store) ->
  search(store)
  units(store)
  url(store)
