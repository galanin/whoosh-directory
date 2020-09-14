import React from 'react';
import SvgIcon from '@components/common/SvgIcon';

const div = React.createFactory('div');
const svg = React.createFactory(SvgIcon);

import LeaderMan from '@icons/common-avatars/leader-man.svg';
import LeaderWoman from '@icons/common-avatars/leader-woman.svg';
import SpecialistMan from '@icons/common-avatars/specialist-man.svg';
import SpecialistWoman from '@icons/common-avatars/specialist-woman.svg';
import AuxiliaryMan from '@icons/common-avatars/auxiliary-man.svg';
import AuxiliaryWoman from '@icons/common-avatars/auxiliary-woman.svg';
import EmployeeMan from '@icons/common-avatars/employee-man.svg';
import EmployeeWoman from '@icons/common-avatars/employee-woman.svg';
import WorkerMan from '@icons/common-avatars/worker-man.svg';
import WorkerWoman from '@icons/common-avatars/worker-woman.svg';
import AuxiliaryWorkerMan from '@icons/common-avatars/auxiliary-worker-man.svg';
import AuxiliaryWorkerWoman from '@icons/common-avatars/auxiliary-worker-woman.svg';
import ScientistMan from '@icons/common-avatars/scientist-man.svg';
import ScientistWoman from '@icons/common-avatars/scientist-woman.svg';
import AssistantMan from '@icons/common-avatars/assistant-man.svg';
import AssistantWoman from '@icons/common-avatars/assistant-woman.svg';
import LawyerMan from '@icons/common-avatars/lawyer-man.svg';
import LawyerWoman from '@icons/common-avatars/lawyer-woman.svg';
import OfficerMan from '@icons/common-avatars/officer.svg';
import NurseWoman from '@icons/common-avatars/nurse.svg';

const AVATARS = {
  M: {
    manager: LeaderMan,
    engineer: SpecialistMan,
    auxiliary: AuxiliaryMan,
    employee: EmployeeMan,
    aux_employee: EmployeeMan,
    worker: WorkerMan,
    aux_worker: AuxiliaryWorkerMan,
    scientist: ScientistMan,
    assistant: AssistantMan,
    lawyer: LawyerMan,
    officer: OfficerMan,
    nurse: null
  },

  F: {
    manager: LeaderWoman,
    engineer: SpecialistWoman,
    auxiliary: AuxiliaryWoman,
    employee: EmployeeWoman,
    aux_employee: EmployeeWoman,
    worker: WorkerWoman,
    aux_worker: AuxiliaryWorkerWoman,
    scientist: ScientistWoman,
    assistant: AssistantWoman,
    lawyer: LawyerWoman,
    officer: null,
    nurse: NurseWoman
  }
};

class CommonAvatar extends React.Component {
  render() {
    const avatar =
      AVATARS[this.props.gender] != null
        ? AVATARS[this.props.gender][this.props.post_code]
        : undefined;

    if (avatar) {
      return div(
        { className: 'common-avatar ' + this.props.className },
        svg({ svg: avatar })
      );
    } else {
      return '';
    }
  }
}

export default CommonAvatar;
