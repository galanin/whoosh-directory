import React from 'react';

const createFactory = (component) => (attrs, ...content) => {
  return React.createElement(component, attrs, ...content);
};

export const div = createFactory('div');
export const a = createFactory('a');
export const span = createFactory('span');
export const img = createFactory('img');
export const input = createFactory('input');

import SvgIcon from '@components/common/SvgIcon';
export const svgIcon = createFactory(SvgIcon);

import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
export const someoneWithButtons = createFactory(SomeoneWithButtons);

import Employee from '@components/staff/Employee';
export const employee = createFactory(Employee);

import EmployeeWithButtons from '@components/staff/EmployeeWithButtons';
export const employeeWithButtons = createFactory(EmployeeWithButtons);

import NodeEmploymentInfo from '@components/staff/NodeEmploymentInfo';
export const nodeEmploymentInfo = createFactory(NodeEmploymentInfo);

import ToCall from '@components/staff/ToCall';
export const toCall = createFactory(ToCall);

import SearchResultUnit from '@components/staff/SearchResultUnit';
export const searchResultUnit = createFactory(SearchResultUnit);

import NodeUnitInfo from '@components/staff/NodeUnitInfo';
export const nodeUnitInfo = createFactory(NodeUnitInfo);

import Contact from '@components/staff/Contact';
export const contact = createFactory(Contact);

import ConnectedContact from '@components/staff/Contact';
export const connectedContact = createFactory(ConnectedContact);

import ToolbarButton from '@components/common/Toolbar/button';
export const toolbarButton = createFactory(ToolbarButton);

import MenuButton from '@components/common/Menu/Button';
export const menuButton = createFactory(MenuButton);

import SettingsBooleanButtons from '@components/common/Settings/BooleanButton';
export const settingsBooleanButtons = createFactory(
  SettingsBooleanButtons
);

import IconedData from '@components/contact_info/IconedData';
export const iconedData = createFactory(IconedData);

import { Element as ScrollElement } from 'react-scroll';
export const scrollElement = createFactory(ScrollElement);
export { scroller } from 'react-scroll';

import Birthday from '@components/contact_info/Birthday';
export const birthday = createFactory(Birthday);

import Birthdays from '@components/staff/Birthdays';
export const birthdays = createFactory(Birthdays);

import BirthdayShortcut from '@components/staff/BirthdayShortcut';
export const birthdayShortcut = createFactory(BirthdayShortcut);

import BirthdayShortcutPanel from '@components/staff/BirthdayShortcutPanel';
export const birthdayShortcutPanel = createFactory(BirthdayShortcutPanel);

import CommonAvatar from '@components/staff/CommonAvatar';
export const commonAvatar = createFactory(CommonAvatar);

import Silhouette from '@components/contact_info/CommonSilhouette';
export const silhouette = createFactory(Silhouette);

import SomeoneButtons from '@components/common/SomeoneButtons';
export const someoneButtons = createFactory(SomeoneButtons);

import Phones from '@components/contact_info/Phones';
export const phones = createFactory(Phones);

import Email from '@components/contact_info/Email';
export const email = createFactory(Email);

import OfficeLocation from '@components/contact_info/OfficeLocation';
export const officeLocation = createFactory(OfficeLocation);

import LunchBreak from '@components/contact_info/LunchBreak';
export const lunchBreak = createFactory(LunchBreak);

import NodeLink from '@components/staff/NodeLink';
export const nodeLink = createFactory(NodeLink);

import Node from '@components/staff/Node';
export const node = createFactory(Node);

import SearchPanel from '@components/staff/SearchPanel';
export const searchPanel = createFactory(SearchPanel);

import SettingsPanel from '@components/staff/SettingsPanel';
export const settingsPanel = createFactory(SettingsPanel);

import ToCallPanel from '@components/staff/ToCallPanel';
export const toCallPanel = createFactory(ToCallPanel);

import FavoritesPanel from '@components/staff/FavoritesPanel';
export const favoritesPanel = createFactory(FavoritesPanel);

import NodeInfo from '@components/staff/NodeInfo';
export const nodeInfo = createFactory(NodeInfo);

import OrganizationStructure from '@components/staff/OrganizationStructure';
export const organizationStructure = createFactory(OrganizationStructure);

import EmployeeInfo from '@components/staff/EmployeeInfo';
export const employeeInfo = createFactory(EmployeeInfo);

import ContactInfo from '@components/staff/ContactInfo';
export const contactInfo = createFactory(ContactInfo);

import EmployeeDummyInfo from '@components/staff/EmployeeDummyInfo';
export const employeeDummyInfo = createFactory(EmployeeDummyInfo);

import SearchResults from '@components/staff/SearchResults';
export const searchResults = createFactory(SearchResults);

import ToCallList from '@components/staff/ToCallList';
export const toCallList = createFactory(ToCallList);

import FavoritesList from '@components/staff/FavoritesList';
export const favoritesList = createFactory(FavoritesList);
