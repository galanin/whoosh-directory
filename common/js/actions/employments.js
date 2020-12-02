import { Request } from '@lib/request';
import { filter, join, isEmpty } from 'lodash';

import { ADD_EMPLOYMENTS } from '@constants/employments';
import { addPeople } from '@actions/people';
import { addUnits } from '@actions/units';

export const addEmployments = employments => ({
  type: ADD_EMPLOYMENTS,
  employments
});

export const getNodeParents = (state, employment) => {
  if (isEmpty(state.nodes.tree)) {
    return [];
  }

  const node_ids = getNodeParentIds(state, employment);

  return node_ids.map(node_id => {
    const node = state.nodes.data[node_id];
    const unit = state.units[node?.unit_id];
    const head = state.employments[unit?.head_id];
    employment = state.employments[node?.employment_id];

    return {
      node,
      unit,
      head,
      employment
    };
  });
};

export const getNodeParentIds = (state, employment) => {
  let tree_node;
  if (isEmpty(state.nodes.tree)) {
    return [];
  }

  if (employment.parent_node_id) {
    tree_node = state.nodes.tree[employment.parent_node_id];
    if (employment.is_head) {
      return tree_node.path;
    } else {
      return tree_node.full_path;
    }
  } else if (employment.node_id) {
    tree_node = state.nodes.tree[employment.node_id];
    return tree_node.path;
  } else {
    return [];
  }
};

const getMissingUnitIds = (state, unit_ids) =>
  unit_ids.filter(unit_id => state.units[unit_id] == null);

export const getParentUnits = (state, employment) =>
  getNodeParentIds(state, employment).map(u_id => state.units[u_id]);

export const getParentEmployIds = (state, employment) => {
  const raw_employ_ids = getParentUnits(state, employment).map(
    unit => unit.employ_ids?.[0]
  );
  return filter(raw_employ_ids);
};

const getMissingParentEmployIds = (state, employment) => {
  const parent_employ_ids = getParentEmployIds(state, employment);
  const raw_employ_ids = parent_employ_ids.map(e_id =>
    state.employments[e_id] ? false : e_id
  );
  return filter(raw_employ_ids);
};

export const loadEmployments = employment_ids => (dispatch, getState) =>
  Request.get('/employments/' + join(employment_ids, ',')).then(response => {
    dispatch(addPeople(response.body.people));
    return dispatch(addEmployments(response.body.employments));
  });

export const loadUnitHierarchy = employment_id => (dispatch, getState) => {
  const state = getState();
  const employment = state.employments[employment_id];
  const parent_unit_ids = getNodeParentIds(state, employment);
  const missing_unit_title_ids = getMissingUnitIds(state, parent_unit_ids);
  if (missing_unit_title_ids.length > 0) {
    return Request.get(
      '/units/titles/' + join(missing_unit_title_ids, ',')
    ).then(response => dispatch(addUnits(response.body.units)));
  }
};

export const loadEmploymentHierarchy = employment_id => (
  dispatch,
  getState
) => {
  const state = getState();
  const employment = state.employments[employment_id];
  const missing_employ_ids = getMissingParentEmployIds(state, employment);
  if (missing_employ_ids.length > 0) {
    return dispatch(loadEmployments(missing_employ_ids));
  }
};
