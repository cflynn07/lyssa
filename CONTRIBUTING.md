Contributing Guide
==================

- <b>Mandatory</b>: write javascript in `coffee-script` and html in `jade`
    - Use nodefront to compile as you work
- 2 spaces per indentation
- use `camelCase` not `snake_case` for EVERYTHING
- 'single quotes' to encapsulate strings, not "double quotes" in coffee-script
- <b>Important</b>: Practice neat vertical-alignment of assignment operators, object properties, etc.
  - <b>BAD</b>:
    <pre>
      controller = require 'controller'
      async = require 'async'
      _ = require 'underscore'

      foo = 
          bar: 'biz'
          bang: 'pop'
          top: 'stop'
          wildWildWest: 'fest'
    </pre>
  - <b>GOOD</b>
    <pre>
      controller = require 'controller'
      async      = require 'async'
      _          = require 'underscore'

      foo = 
          bar:          'biz'
          bang:         'pop'
          top:          'stop'
          wildWildWest: 'fest'
    </pre>
