#
# # NOTify
#




module.exports = -> (files, metalsmith, done) ->
  for name, file of files
    parts = name.split '/'
    if parts[0] isnt 'notcode' then continue
    parts[0] = '!code'
    newName = parts.join '/'
    delete files[name]
    file.file = newName
    files[newName] = file
  done()
