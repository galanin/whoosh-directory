import React from 'react';

// export const span = (attrs, content) => React.createElement('span', attrs, content);

export const div = React.createFactory('div');
export const a = React.createFactory('a');
export const span = React.createFactory('span');
export const img = React.createFactory('img');
export const input = React.createFactory('input');

import SvgIcon from '@components/common/SvgIcon';
export const svgIcon = React.createFactory(SvgIcon);

import SomeoneWithButtons from '@components/staff/SomeoneWithButtons';
export const someoneWithButtons = React.createFactory(SomeoneWithButtons);

import Employee from '@components/staff/Employee';
export const employee = React.createFactory(Employee);

import EmployeeWithButtons from '@components/staff/EmployeeWithButtons';
export const employeeWithButtons = React.createFactory(EmployeeWithButtons);

import NodeEmploymentInfo from '@components/staff/NodeEmploymentInfo';
export const nodeEmploymentInfo = React.createFactory(NodeEmploymentInfo);

import ToCall from '@components/staff/ToCall';
export const toCall = React.createFactory(ToCall);

import SearchResultUnit from '@components/staff/SearchResultUnit';
export const searchResultUnit = React.createFactory(SearchResultUnit);

import NodeUnitInfo from '@components/staff/NodeUnitInfo';
export const nodeUnitInfo = React.createFactory(NodeUnitInfo);

import Contact from '@components/staff/Contact';
export const contact = React.createFactory(Contact);

import ConnectedContact from '@components/staff/Contact';
export const connectedContact = React.createFactory(ConnectedContact);

import ToolbarButton from '@components/common/Toolbar/button';
export const toolbarButton = React.createFactory(ToolbarButton);

import MenuButton from '@components/common/Menu/Button';
export const menuButton = React.createFactory(MenuButton);

import SettingsBooleanButtons from '@components/common/Settings/BooleanButton';
export const settingsBooleanButtons = React.createFactory(
  SettingsBooleanButtons
);

import IconedData from '@components/contact_info/IconedData';
export const iconedData = React.createFactory(IconedData);

import { Element as ScrollElement, scroller as Scroller } from 'react-scroll';
export const scrollElement = React.createFactory(ScrollElement);
export const scroller = React.createFactory(Scroller);

import BirthdayShortcut from '@components/staff/BirthdayShortcut';
export const birthdayShortcut = React.createFactory(BirthdayShortcut);

import CommonAvatar from '@components/staff/CommonAvatar';
export const commonAvatar = React.createFactory(CommonAvatar);

import Silhouette from '@components/contact_info/CommonSilhouette';
export const silhouette = React.createFactory(Silhouette);

import SomeoneButtons from '@components/common/SomeoneButtons';
export const someoneButtons = React.createFactory(SomeoneButtons);

import Phones from '@components/contact_info/Phones';
export const phones = React.createFactory(Phones);

import Email from '@components/contact_info/Email';
export const email = React.createFactory(Email);

import OfficeLocation from '@components/contact_info/OfficeLocation';
export const officeLocation = React.createFactory(OfficeLocation);

import LunchBreak from '@components/contact_info/LunchBreak';
export const lunchBreak = React.createFactory(LunchBreak);

import Birthday from '@components/contact_info/Birthday';
export const birthday = React.createFactory(Birthday);

import NodeLink from '@components/staff/NodeLink';
export const nodeLink = React.createFactory(NodeLink);

import Node from '@components/staff/Node';
export const node = React.createFactory(Node);

import SearchPanel from '@components/staff/SearchPanel';
export const searchPanel = React.createFactory(SearchPanel);

import BirthdayShortcutPanel from '@components/staff/BirthdayShortcutPanel';
export const birthdayShortcutPanel = React.createFactory(BirthdayShortcutPanel);

import SettingsPanel from '@components/staff/SettingsPanel';
export const settingsPanel = React.createFactory(SettingsPanel);

import ToCallPanel from '@components/staff/ToCallPanel';
export const toCallPanel = React.createFactory(ToCallPanel);

import FavoritesPanel from '@components/staff/FavoritesPanel';
export const favoritesPanel = React.createFactory(FavoritesPanel);

import NodeInfo from '@components/staff/NodeInfo';
export const nodeInfo = React.createFactory(NodeInfo);

import OrganizationStructure from '@components/staff/OrganizationStructure';
export const organizationStructure = React.createFactory(OrganizationStructure);

import EmployeeInfo from '@components/staff/EmployeeInfo';
export const employeeInfo = React.createFactory(EmployeeInfo);

import ContactInfo from '@components/staff/ContactInfo';
export const contactInfo = React.createFactory(ContactInfo);

import EmployeeDummyInfo from '@components/staff/EmployeeDummyInfo';
export const employeeDummyInfo = React.createFactory(EmployeeDummyInfo);

import SearchResults from '@components/staff/SearchResults';
export const searchResults = React.createFactory(SearchResults);

import Birthdays from '@components/staff/Birthdays';
export const birthdays = React.createFactory(Birthdays);

import ToCallList from '@components/staff/ToCallList';
export const toCallList = React.createFactory(ToCallList);

import FavoritesList from '@components/staff/FavoritesList';
export const favoritesList = React.createFactory(FavoritesList);
