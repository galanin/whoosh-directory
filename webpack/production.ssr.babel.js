import nodeExternals from 'webpack-node-externals';
import merge from 'webpack-merge';
import path from 'path';
import config from '../config';
import babelOpts from './babel.config.ssr';
import { enableDynamicImports } from '../config';
import baseConfig, { basePlugins, analyzeBundle } from './base';
import { set, filter } from 'lodash';

const allowedPlugin = (plugin, key) => {
  switch (key) {
    case 'reactLoadablePlugin':
      return enableDynamicImports;
    case 'isomorphicPlugin':
      return false;
    case 'bundleAnalyzerPlugin':
      return analyzeBundle;
    default:
      return true;
  }
};

export default merge.strategy({
  entry: 'replace',
  plugins: 'replace',
  module: 'replace',
  optimization: 'replace'
})(baseConfig, {
  context: null,
  mode: 'development',
  optimization: {
    splitChunks: {
      chunks: 'all',
      name: true
    }
  },
  target: 'node',
  entry: ['./server/renderer/handler.js'],
  externals: [
    // images are handled by isomorphic webpack.
    // html files are required directly
    /\.(html|png|gif|jpg)$/,
    // treat all node modules as external to keep this bundle small
    nodeExternals()
  ],
  output: {
    path: path.join(__dirname, '..', process.env.OUTPUT_PATH, 'renderer'),
    filename: 'handler.built.js',
    libraryTarget: 'commonjs'
  },
  plugins: [...filter(basePlugins, allowedPlugin)],
  module: {
    rules: [
      {
        test: /\.js|jsx$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          // tell babel to uglify production server code for SSR rendering
          options: set(babelOpts, 'presets[0][1].targets.uglify', true)
        }
      },
      {
        test: /\.scss$/,
        exclude: [
          path.resolve(__dirname, '../node_modules'),
          path.resolve(__dirname, '../common/css/base')
        ],
        use: [
          {
            loader: 'css-loader/locals',
            options: {
              modules: true,
              minimize: false,
              importLoaders: 0,
              localIdentName: config.cssModulesIdentifier
            }
          },
          { loader: 'postcss-loader' },
          { loader: 'sass-loader' },
          {
            loader: 'sass-resources-loader',
            options: {
              resources: './common/css/resources/*.scss'
            }
          }
        ]
      },
      {
        test: /\.svg$/,
        use: [
          {
            loader: 'raw-loader'
          },
          {
            loader: 'svgo-loader',
            options: {
              plugins: [
                {cleanupAttrs: true},
                {removeDoctype: true},
                {removeXMLProcInst: true},
                {removeComments: true},
                {removeMetadata: true},
                {removeTitle: true},
                {removeDesc: true},
                {removeUselessDefs: true},
                {removeXMLNS: true},
                {removeEditorsNSData: true},
                {removeEmptyAttrs: true},
                {removeHiddenElems: true},
                {removeEmptyText: true},
                {removeEmptyContainers: true},
                {cleanupEnableBackground: true},
                {convertColors: {shorthex: true}},
                {convertPathData: true},
                {convertTransform: true},
                {removeUnknownsAndDefaults: true},
                {removeNonInheritableGroupAttrs: true},
                {removeUselessStrokeAndFill: true},
                {removeUnusedNS: true},
                {cleanupIDs: true},
                {cleanupNumericValues: true},
                {cleanupListOfValues: true},
                {collapseGroups: true},
                {removeRasterImages: true},
                {convertShapeToPath: true},
                {removeDimensions: true},
                {removeStyleElement: true},
                {removeScriptElement: true},
                {removeViewBox: false},
              ],
              floatPrecision: 2
            }
          }
        ]
      }
    ]
  }
});
