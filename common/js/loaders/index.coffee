import birthdays from '@loaders/birthdays'
import employments from '@loaders/employments'
import search from '@loaders/search'
import units from '@loaders/units'

export default (store) ->
  birthdays(store)
  employments(store)
  search(store)
  units(store)
