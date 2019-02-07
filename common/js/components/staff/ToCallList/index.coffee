import React from 'react'
import { connect } from 'react-redux'
import { isArray, isEmpty } from 'lodash'

import SvgIcon from '@components/common/SvgIcon'
import ToCallIcon from '@icons/call.svg'
import CheckedIcon from '@icons/checked.svg'
import EmployeeToCall from '@components/staff/EmployeeToCall'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

employee = React.createFactory(EmployeeToCall)


mapStateToProps = (state, ownProps) ->
  data: state.to_call?.data
  unchecked: state.to_call?.unchecked
  checked: state.to_call?.checked


mapDispatchToProps = (dispatch) ->
  {}


class ToCallList extends React.Component
  render: ->
    div { className: 'to-call-list__scroller plug' },
      div { className: 'to-call-list' },
        div { className: 'to-call-list__title' },
          'Планировщик'

        div { className: 'to-call-list__subtitle' },
          'Позвонить'

        if isEmpty(@props.unchecked)
          div { className: 'to-call-list__empty-note' },
            'Этот список нужен для того, чтобы никому не забыть позвонить. Добавляйте в него коллег с помощью кнопки '
            svg { className: 'to-call-list__button-icon', svg: ToCallIcon }
            '.'

        if isArray(@props.unchecked) and !isEmpty(@props.unchecked)
          div { className: 'to-call-list__unchecked' },
            for to_call_id in @props.unchecked
              to_call = @props.data[to_call_id]
              if to_call?
                employee { key: to_call.id, to_call_id: to_call.id, className: 'list-item shadow' }

        div { className: 'to-call-list__subtitle' },
          'Выполнено'

        if isEmpty(@props.checked)
          div { className: 'to-call-list__empty-note' },
            'Этот список нужен, чтобы хранить историю сделанный работы. Перемещайте в него коллег с помощью кнопки '
            svg { className: 'to-call-list__button-icon', svg: CheckedIcon }
            ' или повторного нажатия кнопки '
            svg { className: 'to-call-list__button-icon', svg: ToCallIcon }
            '.'

        if isArray(@props.checked) and !isEmpty(@props.checked)
          div { className: 'to-call-list__checked' },
            for to_call_id in @props.checked
              to_call = @props.data[to_call_id]
              if to_call?
                employee { key: to_call.id, to_call_id: to_call.id, className: 'list-item shadow' }


export default connect(mapStateToProps, mapDispatchToProps)(ToCallList)
