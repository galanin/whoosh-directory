import React from 'react'
import classNames from 'classnames'

import SearchResultUnit from '@components/staff/SearchResultUnit'
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons'

div = React.createFactory('div')
unit = React.createFactory(SearchResultUnit)
employee = React.createFactory(SomeoneWithButtons)


class ComboUnitEmployee extends React.Component

  render: ->

    class_names =
      'combo-unit-employee' : true
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      if @props.unit_id?
        unit { unit_id: @props.unit_id }
      if @props.employment_id?
        employee { employment_id: @props.employment_id, hide: { unit: true } }


export default ComboUnitEmployee
