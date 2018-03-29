import agent from './agent'
import {
} from './actions'

promiseMiddleware = (store) ->
  (next) ->
    (action) ->
      next(action)


localStorageMiddleware = (store) ->
  (next) ->
    (action) ->
      # do action
      next(action)

isPromise = (v) ->
  v && typeof v.then == 'function'


export { promiseMiddleware, localStorageMiddleware }
