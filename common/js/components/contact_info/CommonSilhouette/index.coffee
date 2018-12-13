import React from 'react'
import PropTypes from 'prop-types'
import SvgIcon from '@components/common/SvgIcon'
import classNames from 'classnames'

svg = React.createFactory(SvgIcon)

import ManSilhouette from '@icons/businessman.svg'
import WomanSilhouette from '@icons/businesswoman.svg'

silhouettes =
  M: ManSilhouette
  F: WomanSilhouette


class CommonSilhouette extends React.Component
  render: ->
    silhouette = silhouettes[@props.gender] or if Math.random() < .5 then ManSilhouette else WomanSilhouette
    class_names =
      'common-silhouette' : true
    class_names[@props.className] = true

    svg { svg: silhouette, className: classNames(class_names) }


export default CommonSilhouette
