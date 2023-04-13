const railsEnv = process.env.RAILS_ENV || 'development'
const optimize = railsEnv !== 'development'

const path = require('path')
const { default: importGlob } = require('esbuild-plugin-import-glob')
const { sassPlugin } = require('esbuild-sass-plugin')

require('esbuild')
  .build({
    entryPoints: [
      'application.js',
    ],
    bundle: true,
    outdir: path.join(process.cwd(), 'app/assets/builds'),
    absWorkingDir: path.join(process.cwd(), 'app/assets/javascripts'),
    color: true,
    minify: optimize,
    sourcemap: true,
    plugins: [
      importGlob(),
      sassPlugin({ cache: true }),
    ],
  })
  