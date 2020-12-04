export default {
  babelrc: false,
  presets: [
    [
      '@babel/preset-env',
      {
        targets: {
          ie: '11'
        },
        useBuiltIns: 'entry',
        corejs: { version: '3.8' },
        debug: true
      }
    ],
    ['@babel/preset-react']
  ],
  plugins: [
    '@babel/plugin-transform-modules-commonjs',
    '@babel/plugin-proposal-class-properties',
    '@babel/plugin-proposal-export-default-from',
    '@babel/plugin-proposal-export-namespace-from',
    '@babel/plugin-proposal-object-rest-spread',
    '@babel/plugin-syntax-dynamic-import',
    '@babel/plugin-proposal-optional-chaining',
    [
      'lodash',
      {
        id: ['lodash', 'semantic-ui-react']
      }
    ]
  ],
  env: {
    development: {
      plugins: ['react-hot-loader/babel']
    },
    production: {
      plugins: ['transform-react-remove-prop-types']
    }
  }
};
