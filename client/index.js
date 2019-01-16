import './styles';
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { createBrowserHistory } from 'history';
import configureStore from '@store';
import App from '@containers/App';
import Loadable from 'react-loadable';
import subscribeLoaders from '@loaders';
import subscribeAutomation from '@automation';

// Hydrate the redux store from server state.
const initialState = window.__INITIAL_STATE__;
const history = createBrowserHistory();
const store = configureStore(initialState, history);
subscribeLoaders(store);
subscribeAutomation(store);

// Render the application
window.main = () => {
  Loadable.preloadReady().then(() => {
    ReactDOM.hydrate(
      <Provider store={store}>
        <ConnectedRouter history={history}>
          <App/>
        </ConnectedRouter>
      </Provider>,
      document.getElementById('app')
    );
  });
};
