import React from 'react'
import SvgIcon from '@components/common/SvgIcon'

div = React.createFactory('div')
svg = React.createFactory(SvgIcon)

import LeaderMan   from '@icons/common-avatars/leader-man.svg'
import LeaderWoman from '@icons/common-avatars/leader-woman.svg'
import SpecialistMan   from '@icons/common-avatars/specialist-man.svg'
import SpecialistWoman from '@icons/common-avatars/specialist-woman.svg'
import EmployeeMan   from '@icons/common-avatars/employee-man.svg'
import EmployeeWoman from '@icons/common-avatars/employee-woman.svg'
import WorkerMan   from '@icons/common-avatars/worker-man.svg'
import WorkerWoman from '@icons/common-avatars/worker-woman.svg'
import AuxiliaryWorkerMan   from '@icons/common-avatars/auxiliary-worker-man.svg'
import AuxiliaryWorkerWoman from '@icons/common-avatars/auxiliary-worker-woman.svg'
import NurseWoman from '@icons/common-avatars/nurse.svg'

AVATARS =
  M:
    head:       LeaderMan
    specialist: SpecialistMan
    employee:   EmployeeMan
    worker:     WorkerMan
    aux_worker: AuxiliaryWorkerMan

  F:
    head:       LeaderWoman
    specialist: SpecialistWoman
    employee:   EmployeeWoman
    worker:     WorkerWoman
    aux_worker: AuxiliaryWorkerWoman
    nurse:      NurseWoman


class CommonAvatar extends React.Component
  render: ->
    avatar = AVATARS[@props.gender]?[@props.post_code]

    if avatar?
      div { className: 'common-avatar ' + @props.className },
        svg { svg: avatar }
    else
      ''


export default CommonAvatar
