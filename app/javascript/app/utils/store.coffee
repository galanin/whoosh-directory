import { applyMiddleware, createStore } from 'redux'
import thunk from 'redux-thunk'
import { createLogger } from 'redux-logger'
import { composeWithDevTools } from 'redux-devtools-extension/developmentOnly'
import { routerMiddleware } from 'react-router-redux'

import { promiseMiddleware, localStorageMiddleware } from './middleware'
import reducer from './reducer'
import history from './history'

myRouterMiddleware = routerMiddleware(history)

getMiddleware = ->
  if process.env.NODE_ENV == 'production'
    applyMiddleware(myRouterMiddleware, promiseMiddleware, localStorageMiddleware, thunk)
  else
    applyMiddleware(myRouterMiddleware, promiseMiddleware, localStorageMiddleware, thunk, createLogger())

export default createStore(reducer, composeWithDevTools(getMiddleware()))
