import React from 'react';
import { Switch } from 'react-router-dom';
import { RouteWithSubRoutes } from '@components/common';
import { hot } from 'react-hot-loader';
import routes from '@routes';

const App = () => (
  <Switch>
    {routes.map(route => (
      <RouteWithSubRoutes key={route.path} {...route} />
    ))}
  </Switch>
);

export default hot(module)(App);
