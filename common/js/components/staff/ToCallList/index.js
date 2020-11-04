import React from 'react';
import { connect } from 'react-redux';
import { isArray, isEmpty } from 'lodash';

import { div, svgIcon, toCall } from '@components/factories';

import ToCallIcon from '@icons/call.svg';
import CheckedIcon from '@icons/checked.svg';

const mapStateToProps = (state, ownProps) => ({
  data: state.to_call?.data,
  unchecked: state.to_call?.unchecked,
  checked_today: state.to_call?.checked_today
});

const mapDispatchToProps = dispatch => ({});

class ToCallList extends React.Component {
  toCallListChecked() {
    if (
      isArray(this.props.checked_today) &&
      !isEmpty(this.props.checked_today)
    ) {
      return div(
        { className: 'to-call-list__checked' },
        this.props.checked_today.map(to_call_id => {
          let to_call = this.props.data[to_call_id];
          if (to_call) {
            return toCall({
              key: to_call.id,
              to_call_id: to_call.id,
              className: 'list-item shadow'
            });
          }
        })
      );
    }
  }

  toCallListUnchecked() {
    if (isArray(this.props.unchecked) && !isEmpty(this.props.unchecked)) {
      return div(
        { className: 'to-call-list__unchecked' },
        this.props.unchecked.map(to_call_id => {
          let to_call = this.props.data[to_call_id];
          if (to_call) {
            return toCall({
              key: to_call.id,
              to_call_id: to_call.id,
              className: 'list-item shadow'
            });
          }
        })
      );
    }
  }
  note() {
    if (isEmpty(this.props.checked_today)) {
      return div(
        { className: 'to-call-list__empty-note' },
        'Этот список нужен, чтобы видеть, как хорошо вы сегодня поработали. Перемещайте в него выполненные планы с помощью кнопки ',
        svgIcon({
          className: 'medium-icon to-call-list__button-icon',
          svg: CheckedIcon
        }),
        ' или повторного нажатия кнопки ',
        svgIcon({
          className: 'medium-icon to-call-list__button-icon',
          svg: ToCallIcon
        }),
        '. Записи из этого списка не удаляются — позже они будут доступны в архиве.'
      );
    }
  }

  emptyListNote() {
    if (isEmpty(this.props.unchecked)) {
      return div(
        { className: 'to-call-list__empty-note' },
        'Этот список нужен для того, чтобы никому не забыть позвонить. Добавляйте в него коллег с помощью кнопки ',
        svgIcon({
          className: 'medium-icon to-call-list__button-icon',
          svg: ToCallIcon
        }),
        '.'
      );
    }
  }

  render() {
    return div(
      { className: 'to-call-list__scroller plug' },
      div(
        { className: 'to-call-list' },
        div({ className: 'to-call-list__title' }, 'Планировщик'),

        div({ className: 'to-call-list__subtitle' }, 'Позвонить'),

        this.emptyListNote(),

        this.toCallListUnchecked(),

        div({ className: 'to-call-list__subtitle' }, 'Выполнено'),

        this.note,

        this.toCallListChecked()
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ToCallList);
