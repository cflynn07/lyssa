buster = require 'buster'

buster.testCase 'First Time Testing',
  'state the obvious': ->
    assert(true)
  'do it twice': ->
    assert(true)
  'do it thrice': ->
    assert(true)
buster.testCase '2 Time Testing',
  'state the obvious': ->
    assert(true)
buster.testCase '3 Time Testing',
  'state the obvious': ->
    assert(true)
buster.testCase '4 Time Testing',
  'state the obvious': ->
    assert(true)
buster.testCase '5 Time Testing',
  'state the obvious': ->
    assert(true)
