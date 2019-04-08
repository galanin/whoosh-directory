import yn from 'yn';
import path from 'path';
import webpack from 'webpack';
import IsoPlugin from 'webpack-isomorphic-tools/plugin';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import { BundleAnalyzerPlugin } from 'webpack-bundle-analyzer';
import { ReactLoadablePlugin } from 'react-loadable/webpack';
import { mapValues, keyBy, filter } from 'lodash';
import { _moduleAliases } from '../package.json';
import babelOpts from './babel.config.client';
import {
  enableDynamicImports,
  isomorphicConfig,
  clientEnv,
  cssModulesIdentifier
} from '../config';

const isDev = process.env.NODE_ENV === 'development';
const cwd = process.cwd();

if (isDev) {
  require('dotenv').load();
}

export const isSSR = yn(process.env.SSR) || false;
export const isClient = yn(process.env.CLIENT) || false;
export const analyzeBundle = yn(process.env.ANALYZE) || false;
export const basePlugins = {
  reactLoadablePlugin: new ReactLoadablePlugin({
    filename: path.join(__dirname, '..', 'react-loadable.json')
  }),
  isomorphicPlugin: new IsoPlugin(isomorphicConfig).development(isDev),
  miniExtractPlugin: new MiniCssExtractPlugin({
    filename: '[name].[chunkhash].css'
  }),
  definePlugin: new webpack.DefinePlugin({
    'process.env': mapValues(keyBy(clientEnv), env => {
      return JSON.stringify(process.env[env]);
    })
  }),
  bundleAnalyzerPlugin: new BundleAnalyzerPlugin()
};

const allowedPlugin = (plugin, key) => {
  switch (key) {
    case 'reactLoadablePlugin':
      return enableDynamicImports;
    case 'miniExtractPlugin':
      return !isSSR;
    case 'bundleAnalyzerPlugin':
      return analyzeBundle;
    case 'definePlugin':
      return isClient;
    default:
      return true;
  }
};

export default {
  context: path.resolve(__dirname, '..'),
  mode: isDev ? 'development' : 'production',
  entry: {
    polyfill: ['./client/polyfill'],
    app: ['./client/index']
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        polyfill: {
          name: 'polyfill',
          chunks: 'all',
          reuseExistingChunk: true,
          priority: 1,
          enforce: true,
          // extract to vendor chunk if it's in /babel-polyfill
          test: module => /babel-polyfill/.test(module.context)
        },
        vendor: {
          name: 'vendor',
          chunks: 'all',
          reuseExistingChunk: true,
          priority: 1,
          enforce: true,
          // extract to vendor chunk if it's in /node_modules
          test: module => /node_modules/.test(module.context)
        }
      }
    }
  },
  output: {
    path: path.join(__dirname, '..', process.env.PUBLIC_OUTPUT_PATH),
    filename: '[name].bundle.js',
    publicPath: process.env.PUBLIC_ASSET_PATH || '/',
    chunkFilename: enableDynamicImports ? '[name].bundle.js' : undefined
  },
  resolve: {
    extensions: ['.js', '.jsx', '.scss', '.coffee'],
    alias: mapValues(_moduleAliases, aliasPath =>
      path.join(cwd, ...aliasPath.split('/'))
    )
  },
  plugins: filter(basePlugins, allowedPlugin),
  module: {
    rules: [
      {
        test: /\.jsx$|\.js$/,
        loader: 'babel-loader',
        options: babelOpts
      },
      {
        // For all .scss files that should be modularized. This should exclude
        // anything inside node_modules and everything inside common/css/base
        // since they should be globally scoped.
        test: /\.scss$|\.sass$/,
        exclude: [
          path.resolve(__dirname, '../node_modules'),
          path.resolve(__dirname, '../common/css/base')
        ],
        use: [
          'css-hot-loader',
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              modules: true,
              minimize: false,
              importLoaders: 1,
              localIdentName: cssModulesIdentifier
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
        // for .scss modules that need to be available globally, we don't pass
        // the files through css-loader to be modularized.
        test: /\.scss$|\.sass$/,
        include: [
          path.resolve(__dirname, '../node_modules'),
          path.resolve(__dirname, '../common/css/base')
        ],
        use: [
          'css-hot-loader',
          MiniCssExtractPlugin.loader,
          { loader: 'css-loader' },
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
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader']
      },
      {
        test: basePlugins.isomorphicPlugin.regular_expression('images'),
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 10240
            }
          }
        ]
      },
      {
        // Load fonts using file-loader
        test: /\.(ttf|eot|woff2?)$/,
        loader: 'file-loader'
      },
      {
        test: /\.coffee$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
            options: babelOpts
          },
          {
            loader: 'coffee-loader',
            options: {
              transpile: {
                presets: ['env']
              }
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
};
