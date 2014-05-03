#
# # Metalsmith Build
#
path       = require 'path'
metalsmith = require 'metalsmith'
markdown   = require 'metalsmith-markdown'
permalinks = require 'metalsmith-permalinks'
templates  = require 'metalsmith-templates'



module.exports = build = (callback=->) ->
  metalsmith __dirname
    .source '..'
    .destination 'build'
    .ignore ['.git', '.metalsmith', '.wintergreen']
    .options remove: false
    .use markdown()
    .use templates 'toffee'
    .use permalinks()
    .build callback




if require.main is module then build()
