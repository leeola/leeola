#
# # Metalsmith Build
#
path        = require 'path'
metalsmith  = require 'metalsmith'
collections = require 'metalsmith-collections'
markdown    = require 'metalsmith-markdown'
permalinks  = require 'metalsmith-permalinks'
templates   = require 'metalsmith-templates'
paginate    = require './plugins/paginate'
NOTify      = require './plugins/notify'



module.exports = build = (callback=->) ->
  metalsmith __dirname
    .source '..'
    .destination 'build'
    .ignore [
      '.git', '.metalsmith', '.wintergreen'
      '.agignore', '.gitignore'
      ]
    .options remove: false
    .use markdown()
    .use collections
      notcode:
        pattern: 'notcode/**/*.html'
        sortBy: 'date'
    .use paginate
      collection: 'notcode'
      perPage: 10
      output: '!code'
      metadata:
        pageName: '!code'
        template: 'notcode.toffee'
    .use NOTify()
    .use permalinks()
    .use templates 'toffee'
    .build callback




if require.main is module then build()
