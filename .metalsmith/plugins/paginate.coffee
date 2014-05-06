#
# # Paginate
#
# An early copy of metalsmith-paginate-deux.
#
path  = require 'path'
clone = require 'clone'



module.exports = (opts={}) ->
  opts.limit     ?= null
  opts.perPage   ?= 10
  opts.startPage ?= 1
  opts.metadata  ?= {}

  if not opts.output?
    console.warn 'paginate-deux requires output filename'
    return done()

  prettyOutput = (out, index) ->
    # In the future we'll support multiple styles of output, such as
    # - foo, foo-2, foo-3
    # - foo/index, foo/page2, foo/page3
    # - foo/index, foo/index-2, foo/index-3
    # - foo/index, foo/2/index, foo/3/index

    base = path.basename out, '.html'
    if index is 0 then return base
    if base is 'index'
      return "page-#{index}"
    else
      return "#{base}-#{index}"

  (files, metalsmith, done) ->
    metadata = metalsmith.metadata()
    cols     = metadata.collections
    col      = cols?[opts.collection]

    if not cols?
      console.warn 'paginate-deux requires metalsmith-collections()'
      return done()

    if not col?
      console.warn "collection '#{opts.collection}' not found."
      return done()

    colCount = col.length
    if opts.limit? and opts.limit < colCount then colCount = opts.limit
    pageCount = Math.ceil colCount / opts.perPage 

    prevPage = null
    for pageIndex in [0...pageCount]
      colStart = pageIndex * opts.perPage
      if pageIndex is pageCount-1
        pageFiles = col[colStart...colCount]
      else
        pageFiles = col[colStart...colStart+opts.perPage]

      page = clone opts.metadata
      page.contents ?= new Buffer('')
      page.mode     ?= '0664'
      page.name     = prettyOutput opts.output, pageIndex
      page.paginate =
        prev: prev
        next: null
        total: pageCount
        current: pageIndex
        files: pageFiles
      pageName = "#{page.name}.html"

      if prevPage? then prev.paginate.next = page
      prev = page

      if files[pageName]?
        console.warn "pageinate-deux unable to create page '#{pageName}',
          it already exists."
        return done()
      
      files[pageName] = page

    # And finally, call done(). Remember, no async in this plugin.
    done()





