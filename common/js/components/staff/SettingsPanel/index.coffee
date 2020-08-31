import React from 'react'
import classNames from 'classnames'

import SettingsBooleanButtons from '@components/common/Settings/BooleanButton'
setting_boolean = React.createFactory(SettingsBooleanButtons)

import SvgIcon from '@components/common/SvgIcon'
import Location from '@icons/location.svg'

div = React.createFactory('div')
span = React.createFactory('span')
svg = React.createFactory(SvgIcon)


class SettingsPanel extends React.Component

  render: ->
    class_names =
      'settings-panel' : true
    class_names[@props.className] = true

    div { className: classNames(class_names) },
      setting_boolean setting: 'search_results__show_location', svg: Location, className: 'settings-panel__button'


export default SettingsPanel
