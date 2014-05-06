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
      blog:
        pattern: 'blog/posts/*.md'
        sortBy: 'date'
    .use paginate
      collection: 'blog'
      perPage: 10
      output: 'blog'
      metadata: template: 'blog.toffee'
    .use permalinks()
    .use templates 'toffee'
    .build callback




if require.main is module then build()
