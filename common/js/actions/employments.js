/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { Request } from '@lib/request';
import { filter, join, isEmpty } from 'lodash';

import { ADD_EMPLOYMENTS } from '@constants/employments';
import { addPeople } from '@actions/people';
import { addUnits } from '@actions/units';


export var addEmployments = employments => ({
  type: ADD_EMPLOYMENTS,
  employments
});


export var getNodeParents = function(state, employment) {
  if (isEmpty(state.nodes.tree)) { return []; }

  const node_ids = getNodeParentIds(state, employment);

  return (() => {
    const result = [];
    for (let node_id of Array.from(node_ids)) {
      const node = state.nodes.data[node_id];
      const unit = state.units[node != null ? node.unit_id : undefined];
      const head = state.employments[unit != null ? unit.head_id : undefined];
      employment = state.employments[node != null ? node.employment_id : undefined];

      result.push({
        node,
        unit,
        head,
        employment
      });
    }
    return result;
  })();
};


export var getNodeParentIds = function(state, employment) {
  let tree_node;
  if (isEmpty(state.nodes.tree)) { return []; }

  if (employment.parent_node_id != null) {
    tree_node = state.nodes.tree[employment.parent_node_id];
    if (employment.is_head) {
      return tree_node.path;
    } else {
      return tree_node.full_path;
    }

  } else if (employment.node_id != null) {
    tree_node = state.nodes.tree[employment.node_id];
    return tree_node.path;

  } else {
    return [];
  }
};


const getMissingUnitIds = (state, unit_ids) => unit_ids.filter(unit_id => state.units[unit_id] == null);


export var getParentUnits = (state, employment) => Array.from(getParentUnitIds(state, employment)).map((u_id) => state.units[u_id]);


export var getParentEmployIds = function(state, employment) {
  const raw_employ_ids = (Array.from(getParentUnits(state, employment)).map((unit) => (unit.employ_ids != null ? unit.employ_ids[0] : undefined)));
  return filter(raw_employ_ids);
};


const getMissingParentEmployIds = function(state, employment) {
  const parent_employ_ids = getParentEmployIds(state, employment);
  const raw_employ_ids = (Array.from(parent_employ_ids).map((e_id) => (state.employments[e_id] ? false : e_id)));
  return filter(raw_employ_ids);
};


export var loadEmployments = employment_ids => (dispatch, getState) => Request.get('/employments/' + join(employment_ids, ',')).then(function(response) {
  dispatch(addPeople(response.body.people));
  return dispatch(addEmployments(response.body.employments));
});


export var loadUnitHierarchy = employment_id => (function(dispatch, getState) {
  const state = getState();
  const employment = state.employments[employment_id];
  const parent_unit_ids = getParentUnitIds(state, employment);
  const missing_unit_title_ids = getMissingUnitTitleIds(state, parent_unit_ids);
  if (missing_unit_title_ids.length > 0) {
    return Request.get('/units/titles/' + join(missing_unit_title_ids, ',')).then(response => dispatch(addUnits(response.body.units)));
  }
});


export var loadEmploymentHierarchy = employment_id => (function(dispatch, getState) {
  const state = getState();
  const employment = state.employments[employment_id];
  const missing_employ_ids = getMissingParentEmployIds(state, employment);
  if (missing_employ_ids.length > 0) {
    return dispatch(loadEmployments(missing_employ_ids));
  }
});
