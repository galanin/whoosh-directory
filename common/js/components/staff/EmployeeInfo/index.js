import React from 'react';
import { connect } from 'react-redux';
import { reverse, isEmpty } from 'lodash';

import {
  div,
  span,
  a,
  img,
  svgIcon,
  silhouette,
  someoneButtons,
  phones,
  email,
  lunchBreak,
  birthday,
  iconedData,
  searchResultUnit,
  someoneWithButtons,
  officeLocation
} from '@components/factories';

import { setCurrentEmploymentId } from '@actions/current';
import { sinkEmployeeInfo, popNodeInfo, popStructure } from '@actions/layout';
import { goToNodeInStructure } from '@actions/nodes';
import { getNodeParents } from '@actions/employments';
import { currentTime, todayDate } from '@lib/datetime';

import CloseButton from '@icons/close_button.svg';
import VacationIcon from '@icons/vacation.svg';

const mapStateToProps = function(state, ownProps) {
  const { employment_id } = state.current;
  const employment = state.employments[employment_id];

  return {
    employment_id,
    employment,
    person: state.people[employment?.person_id],
    dept_id: employment?.dept_id,
    dept: state.nodes.tree[employment?.dept_id],
    node_id: employment?.node_id,
    node: state.nodes.tree[employment?.node_id],
    parent_node_id: employment?.parent_node_id,
    parent_node: state.nodes.tree[employment?.parent_node_id],
    parents: employment && reverse(getNodeParents(state, employment))
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
    if (
      this.props.employment?.lunch_begin &&
      this.props.employment?.lunch_end &&
      this.state?.current_time
    ) {
      return (
        this.props.employment.lunch_begin <= this.state.current_time &&
        this.state.current_time < this.props.employment.lunch_end
      );
    }
  }

  isBirthday() {
    if (this.props.person?.birthday && this.state?.current_date) {
      return this.props.person.birthday === this.state.current_date;
    }
  }

  componentDidMount() {
    this.setCurrentTime();
    return (this.interval = setInterval(() => this.setCurrentTime(), 10000));
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
    return div(
      { className: 'employee-info-container soft-shadow plug' },
      div(
        {
          className: 'employee-info__close-button',
          onClick: this.onCloseButtonClick.bind(this)
        },
        svgIcon({
          className: 'employee-info__close-button-cross',
          svg: CloseButton
        })
      ),

      div(
        { className: 'employee-info-scroller' },

        this.props.employment && this.props.person
          ? div(
            { className: 'employee-info' },
            div(
              { className: 'employee-info__head' },
              div(
                { className: 'employee-info__name' },
                this.props.person.last_name +
                    ' ' +
                    this.props.person.first_name +
                    ' ' +
                    this.props.person.middle_name
              )
            ),

            this.props.node
              ? a(
                {
                  className: 'employee-info__post-title-link',
                  onClick: this.onEmploymentClick.bind(this),
                  href: '/'
                },
                span(
                  { className: 'employee-info__post-title' },
                  this.props.employment.post_title
                )
              )
              : div(
                { className: 'employee-info__post-title' },
                this.props.employment.post_title
              ),

            this.props.dept_id &&
                this.props.dept_id !== this.props.parent_node_id &&
                this.props.dept
              ? a(
                {
                  className: 'employee-info__unit-title-link',
                  onClick: this.onDeptClick.bind(this),
                  href: '/'
                },
                span(
                  { className: 'employee-info__unit-long-title' },
                  this.props.dept.t
                )
              )
              : undefined,

            this.props.parent_node
              ? a(
                {
                  className: 'employee-info__unit-title-link',
                  onClick: this.onUnitClick.bind(this),
                  href: '/'
                },
                span(
                  { className: 'employee-info__unit-long-title' },
                  this.props.parent_node.t
                )
              )
              : undefined,

            div(
              { className: 'employee-info__two-columns' },
              div(
                { className: 'employee-info__photo' },
                this.props.person.photo.large.url
                  ? img({
                    src:
                          process.env.PHOTO_BASE_URL +
                          this.props.person.photo.large.url,
                    className: 'employee-info__photo-large'
                  })
                  : silhouette({
                    className: 'employee-info__avatar',
                    gender: this.props.person.gender
                  })
              ),

              div(
                { className: 'employee-info__data' },
                someoneButtons({ employment_id: this.props.employment_id }),

                phones({
                  format_phones: this.props.employment.format_phones,
                  className:
                      'employee-info__iconed-data employee-info__phones'
                }),

                email({
                  email: this.props.person.email,
                  className: 'employee-info__iconed-data employee-info__email'
                }),

                officeLocation({
                  building: this.props.employment.building,
                  office: this.props.employment.office,
                  className:
                      'employee-info__iconed-data employee-info__location'
                }),

                lunchBreak({
                  lunch_begin: this.props.employment.lunch_begin,
                  lunch_end: this.props.employment.lunch_end,
                  highlighted:
                      !this.props.employment.on_vacation && this.isOnLunchNow(),
                  className:
                      'employee-info__iconed-data employee-info__lunch-break'
                }),

                birthday({
                  birthday_formatted: this.props.person.birthday_formatted,
                  highlighted: this.isBirthday(),
                  className:
                      'employee-info__iconed-data employee-info__birthday'
                }),

                this.props.employment.on_vacation
                  ? iconedData(
                    {
                      className:
                            'employee-info__iconed-data employee-info__vacation',
                      icon: VacationIcon,
                      align_icon: 'middle'
                    },
                    'В отпуске'
                  )
                  : undefined
              )
            ),

            !isEmpty(this.props.parents)
              ? div(
                { className: 'employee-info__structure' },
                div(
                  { className: 'employee-info__structure-title' },
                  'Оргструктура'
                ),

                div(
                  { className: 'employee-info__structure-units' },
                  this.props.parents.map(parent => {
                    if (parent.unit) {
                      return div(
                        {
                          key: parent.unit.id,
                          className: 'list-item hair-border'
                        },
                        searchResultUnit({
                          unit_id: parent.unit.id,
                          className: 'employee-info__structure-unit'
                        }),
                        parent.head
                          ? someoneWithButtons({
                            key: parent.head.id,
                            employment_id: parent.head.id,
                            hide: { unit: true },
                            className:
                                    'employee-info__structure-employment'
                          })
                          : undefined
                      );
                    } else if (parent.employment) {
                      return div(
                        {
                          key: parent.employment.id,
                          className: 'list-item hair-border'
                        },
                        someoneWithButtons({
                          key: parent.employment.id,
                          employment_id: parent.employment.id,
                          hide: { unit: true },
                          className: 'employee-info__structure-employment'
                        })
                      );
                    }
                  })
                )
              )
              : undefined
          )
          : undefined
      )
    );
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(EmployeeInfo);
