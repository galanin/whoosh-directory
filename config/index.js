
module.exports = {
  // Enable or disable server-side rendering
  enableSSR: true,

  // Enable or disable dynamic imports (code splitting)
  enableDynamicImports: true,

  // The env vars to expose on the client side. If you add them here, they will
  // be available on the client as process.env[VAR_NAME], same as they would be
  // in node.js.
  //
  // **WARNING**: Be careful not to expose any secrets here!
  clientEnv: [
    'NODE_ENV',
    'SSR',
    'CLIENT_SIDE_API_BASE_URL',
    'SERVER_SIDE_API_BASE_URL',
    'PHOTO_BASE_URL',
    'KEYBOARD_LAYOUT_FIX'
  ],

  /* The identifier to use for css-modules.
   */
  cssModulesIdentifier: '[name]__[local]__[hash:base64:5]',

  // Isomorphic configuration
  isomorphicConfig: {
    assets: {
      images: {
        extensions: [
          'png',
          'jpg',
          'jpeg',
          'gif',
          'ico'
        ]
      }
    }
  }
};
