const { environment } = require('@rails/webpacker')

environment.loaders.append('coffee', {
  test: /\.coffee$/,
  use: ['cjsx-loader', 'coffee-loader']
})

environment.loaders.append('sass', {
  test: /\.sass$/,
  use: ['style-loader', 'css-loader', 'sass-loader']
})

environment.loaders.append('svg', {
  test: /\.svg$/,
  use: [
    {
      loader: 'svgo-loader',
      options: {
        plugins: [
          { removeStyleElement: true },
          { removeScriptElement: true },
          { removeTitle: true },
          { convertColors: { shorthex: true } },
          { removeViewBox: false },
          { removeDimensions: true }
        ]
      }
    }
  ]
})

module.exports = environment
