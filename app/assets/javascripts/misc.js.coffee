# Fake console.*() calls when necessary, in case dev tools aren't installed
@console ?= do () ->
  c = {}
  [
    'log'
    'debug'
    'info'
    'warn'
    'error'
    'assert'
    'dir'
    'dirxml'
    'group'
    'groupEnd'
    'time'
    'timeEnd'
    'count'
    'trace'
    'profile'
    'profileEnd'
  ].forEach (name) ->
    c[name] = (->)
    return
  c
