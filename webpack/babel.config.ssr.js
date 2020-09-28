export default {
  babelrc: false,
  presets: [
    [
      '@babel/preset-env',
      {
        targets: {
          node: 'current'
        },
      }
    ],
    ['@babel/preset-react']
  ],
  plugins: [
    'react-loadable/babel',
    '@babel/plugin-transform-modules-commonjs',
    '@babel/plugin-proposal-class-properties',
    '@babel/plugin-proposal-export-default-from',
    '@babel/plugin-proposal-export-namespace-from',
    '@babel/plugin-proposal-object-rest-spread',
    '@babel/plugin-proposal-optional-chaining',
    '@babel/plugin-syntax-dynamic-import',
  ],
  env: {
    development: {
      plugins: []
    },
    production: {
      plugins: ['transform-react-remove-prop-types']
    }
  }
};
