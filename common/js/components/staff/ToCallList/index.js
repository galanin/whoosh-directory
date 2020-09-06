/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react';
import { connect } from 'react-redux';
import { isArray, isEmpty } from 'lodash';

import SvgIcon from '@components/common/SvgIcon';
import ToCallIcon from '@icons/call.svg';
import CheckedIcon from '@icons/checked.svg';
import ToCall from '@components/staff/ToCall';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

const employee = React.createFactory(ToCall);

const mapStateToProps = (state, ownProps) => ({
  data: state.to_call != null ? state.to_call.data : undefined,
  unchecked: state.to_call != null ? state.to_call.unchecked : undefined,
  checked_today: state.to_call != null ? state.to_call.checked_today : undefined
});

const mapDispatchToProps = dispatch => ({});

class ToCallList extends React.Component {
  render() {
    let to_call_id, to_call;
    return div(
      { className: 'to-call-list__scroller plug' },
      div(
        { className: 'to-call-list' },
        div({ className: 'to-call-list__title' }, 'Планировщик'),

        div({ className: 'to-call-list__subtitle' }, 'Позвонить'),

        isEmpty(this.props.unchecked)
          ? div(
            { className: 'to-call-list__empty-note' },
            'Этот список нужен для того, чтобы никому не забыть позвонить. Добавляйте в него коллег с помощью кнопки ',
            svg({
              className: 'medium-icon to-call-list__button-icon',
              svg: ToCallIcon
            }),
            '.'
          )
          : undefined,

        isArray(this.props.unchecked) && !isEmpty(this.props.unchecked)
          ? div(
            { className: 'to-call-list__unchecked' },
            (() => {
              const result = [];
              for (to_call_id of Array.from(this.props.unchecked)) {
                to_call = this.props.data[to_call_id];
                if (to_call != null) {
                  result.push(
                    employee({
                      key: to_call.id,
                      to_call_id: to_call.id,
                      className: 'list-item shadow'
                    })
                  );
                } else {
                  result.push(undefined);
                }
              }
              return result;
            })()
          )
          : undefined,

        div({ className: 'to-call-list__subtitle' }, 'Выполнено'),

        isEmpty(this.props.checked_today)
          ? div(
            { className: 'to-call-list__empty-note' },
            'Этот список нужен, чтобы видеть, как хорошо вы сегодня поработали. Перемещайте в него выполненные планы с помощью кнопки ',
            svg({
              className: 'medium-icon to-call-list__button-icon',
              svg: CheckedIcon
            }),
            ' или повторного нажатия кнопки ',
            svg({
              className: 'medium-icon to-call-list__button-icon',
              svg: ToCallIcon
            }),
            '. Записи из этого списка не удаляются — позже они будут доступны в архиве.'
          )
          : undefined,

        isArray(this.props.checked_today) && !isEmpty(this.props.checked_today)
          ? div(
            { className: 'to-call-list__checked' },
            (() => {
              const result1 = [];
              for (to_call_id of Array.from(this.props.checked_today)) {
                to_call = this.props.data[to_call_id];
                if (to_call != null) {
                  result1.push(
                    employee({
                      key: to_call.id,
                      to_call_id: to_call.id,
                      className: 'list-item shadow'
                    })
                  );
                } else {
                  result1.push(undefined);
                }
              }
              return result1;
            })()
          )
          : undefined
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ToCallList);
