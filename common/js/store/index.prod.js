import { compose, createStore, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';
import createRootReducer from '@reducers';
import { routerMiddleware } from 'connected-react-router';


export default function configureStore(initialState, history = null) {
  /* Middleware
   * Configure this array with the middleware that you want included.
   */
  let middleware = [ thunk ];

  if (history) {
    middleware.push(routerMiddleware(history));
  }

  // Add universal enhancers here
  let enhancers = [];

  const enhancer = compose(...[
    applyMiddleware(...middleware),
    ...enhancers
  ]);

  // create store with enhancers, middleware, reducers, and initialState
  const store = createStore(createRootReducer(history), initialState, enhancer);

  return store;
}
