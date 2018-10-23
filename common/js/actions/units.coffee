import { Request } from '@lib/request'

import { SET_UNITS } from '@constants/units'


export loadUnits = ->
  (dispatch) ->
    Request.get('/units').then (result) ->
      dispatch(setUnits(result.body.units))
    , (error) ->


export setUnits = (units) ->
  type: SET_UNITS
  units: units
