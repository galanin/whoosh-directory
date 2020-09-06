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
import SvgIcon from '@components/common/SvgIcon';
import Silhouette from '@components/contact_info/CommonSilhouette';
import SomeoneButtons from '@components/common/SomeoneButtons';
import Phones from '@components/contact_info/Phones';
import Email from '@components/contact_info/Email';
import OfficeLocation from '@components/contact_info/OfficeLocation';
import LunchBreak from '@components/contact_info/LunchBreak';
import Birthday from '@components/contact_info/Birthday';
import IconedData from '@components/contact_info/IconedData';
import SearchResultUnit from '@components/staff/SearchResultUnit';
import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
import { reverse, isEmpty } from 'lodash';

import { setCurrentEmploymentId } from '@actions/current';
import { sinkEmployeeInfo, popNodeInfo, popStructure } from '@actions/layout';
import { goToNodeInStructure } from '@actions/nodes';
import { getNodeParents } from '@actions/employments';
import { currentTime, todayDate } from '@lib/datetime';

const div = React.createFactory('div');
const span = React.createFactory('span');
const a = React.createFactory('a');
const img = React.createFactory('img');
const svg = React.createFactory(SvgIcon);
const silhouette = React.createFactory(Silhouette);
const buttons = React.createFactory(SomeoneButtons);
const phones = React.createFactory(Phones);
const email = React.createFactory(Email);
const location = React.createFactory(OfficeLocation);
const lunch_break = React.createFactory(LunchBreak);
const birthday = React.createFactory(Birthday);
const iconed_data = React.createFactory(IconedData);
const unit = React.createFactory(SearchResultUnit);
const employee = React.createFactory(SomeoneWithButtons);

import CloseButton from '@icons/close_button.svg';
import VacationIcon from '@icons/vacation.svg';


const mapStateToProps = function(state, ownProps) {
  const {
    employment_id
  } = state.current;
  const employment = state.employments[employment_id];

  return {
    employment_id,
    employment,
    person: state.people[employment != null ? employment.person_id : undefined],
    dept_id: (employment != null ? employment.dept_id : undefined),
    dept: state.nodes.tree[employment != null ? employment.dept_id : undefined],
    node_id: (employment != null ? employment.node_id : undefined),
    node: state.nodes.tree[employment != null ? employment.node_id : undefined],
    parent_node_id: (employment != null ? employment.parent_node_id : undefined),
    parent_node: state.nodes.tree[employment != null ? employment.parent_node_id : undefined],
    parents: (employment != null) && reverse(getNodeParents(state, employment))
  };
};


const mapDispatchToProps = dispatch => ({
  unsetCurrentEmployee() {
    dispatch(sinkEmployeeInfo());
    return dispatch(setCurrentEmploymentId(null));
  },

  goToNode(node_id) {
    dispatch(goToNodeInStructure(node_id));
    dispatch(popNodeInfo());
    return dispatch(popStructure());
  }
});


class EmployeeInfo extends React.Component {

  setCurrentTime() {
    return this.setState({
      current_time: currentTime(),
      current_date: todayDate()
    });
  }


  isOnLunchNow() {
    if (((this.props.employment != null ? this.props.employment.lunch_begin : undefined) != null) && ((this.props.employment != null ? this.props.employment.lunch_end : undefined) != null) && ((this.state != null ? this.state.current_time : undefined) != null)) {
      return this.props.employment.lunch_begin <= this.state.current_time && this.state.current_time < this.props.employment.lunch_end;
    }
  }


  isBirthday() {
    if (((this.props.person != null ? this.props.person.birthday : undefined) != null) && (this.state != null ? this.state.current_date : undefined)) {
      return this.props.person.birthday === this.state.current_date;
    }
  }


  componentDidMount() {
    this.setCurrentTime();
    return this.interval = setInterval((() => this.setCurrentTime()), 10000);
  }


  componentWillUnmount() {
    return clearInterval(this.interval);
  }


  onCloseButtonClick() {
    return this.props.unsetCurrentEmployee();
  }


  onDeptClick(e) {
    e.preventDefault();
    return this.props.goToNode(this.props.employment.dept_id);
  }


  onUnitClick(e) {
    e.preventDefault();
    return this.props.goToNode(this.props.employment.parent_node_id);
  }


  onEmploymentClick(e) {
    e.preventDefault();
    return this.props.goToNode(this.props.employment.node_id);
  }


  render() {
    return div({ className: 'employee-info-container soft-shadow plug' },
      div({ className: 'employee-info__close-button', onClick: this.onCloseButtonClick.bind(this) },
        svg({ className: 'employee-info__close-button-cross', svg: CloseButton })),

      div({ className: 'employee-info-scroller' },

        (this.props.employment != null) && (this.props.person != null) ?

          div({ className: 'employee-info' },
            div({ className: 'employee-info__head' },
              div({ className: 'employee-info__name' },
                this.props.person.last_name + ' ' + this.props.person.first_name + ' ' + this.props.person.middle_name)
            ),

            (this.props.node != null) ?
              a({ className: 'employee-info__post-title-link', onClick: this.onEmploymentClick.bind(this), href: '/' },
                span({ className: 'employee-info__post-title' },
                  this.props.employment.post_title)
              )
              :
              div({ className: 'employee-info__post-title' },
                this.props.employment.post_title),

            (this.props.dept_id != null) && (this.props.dept_id !== this.props.parent_node_id) && (this.props.dept != null) ?
              a({ className: 'employee-info__unit-title-link', onClick: this.onDeptClick.bind(this), href: '/' },
                span({ className: 'employee-info__unit-long-title' },
                  this.props.dept.t)
              ) : undefined,

            (this.props.parent_node != null) ?
              a({ className: 'employee-info__unit-title-link', onClick: this.onUnitClick.bind(this), href: '/' },
                span({ className: 'employee-info__unit-long-title' },
                  this.props.parent_node.t)
              ) : undefined,

            div({ className: 'employee-info__two-columns' },
              div({ className: 'employee-info__photo' },
                this.props.person.photo.large.url ?
                  img({ src: process.env.PHOTO_BASE_URL + this.props.person.photo.large.url, className: 'employee-info__photo-large' })
                  :
                  silhouette({ className: 'employee-info__avatar', gender: this.props.person.gender })),

              div({ className: 'employee-info__data' },
                buttons({ employment_id: this.props.employment_id }),

                phones({ format_phones: this.props.employment.format_phones, className: 'employee-info__iconed-data employee-info__phones' }),

                email({ email: this.props.person.email, className: 'employee-info__iconed-data employee-info__email' }),

                location({ building: this.props.employment.building, office: this.props.employment.office, className: 'employee-info__iconed-data employee-info__location' }),

                lunch_break({ lunch_begin: this.props.employment.lunch_begin, lunch_end: this.props.employment.lunch_end, highlighted: !this.props.employment.on_vacation && this.isOnLunchNow(), className: 'employee-info__iconed-data employee-info__lunch-break' }),

                birthday({ birthday_formatted: this.props.person.birthday_formatted, highlighted: this.isBirthday(), className: 'employee-info__iconed-data employee-info__birthday' }),

                this.props.employment.on_vacation ?
                  iconed_data({ className: 'employee-info__iconed-data employee-info__vacation', icon: VacationIcon, align_icon: 'middle' },
                    'В отпуске') : undefined
              )
            ),

            !isEmpty(this.props.parents) ?
              div({ className: 'employee-info__structure' },
                div({ className: 'employee-info__structure-title' },
                  'Оргструктура'),

                div({ className: 'employee-info__structure-units' },
                  (() => {
                    const result = [];
                    for (let parent of Array.from(this.props.parents)) {
                      if (parent.unit != null) {
                        result.push(div({ key: parent.unit.id, className: 'list-item hair-border' },
                          unit({unit_id: parent.unit.id, className: 'employee-info__structure-unit'}),
                          (parent.head != null) ?
                            employee({key: parent.head.id, employment_id: parent.head.id, hide: { unit: true }, className: 'employee-info__structure-employment'}) : undefined
                        ));

                      } else if (parent.employment != null) {
                        result.push(div({ key: parent.employment.id, className: 'list-item hair-border' },
                          employee({key: parent.employment.id, employment_id: parent.employment.id, hide: { unit: true }, className: 'employee-info__structure-employment'})));
                      } else {
                        result.push(undefined);
                      }
                    }
                    return result;
                  })()
                )
              ) : undefined
          ) : undefined
      )
    );
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo);
