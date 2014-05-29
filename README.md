# Method *not* missing
[![Build Status](https://travis-ci.org/Jell/method_not_missing.svg?branch=master)](https://travis-ci.org/Jell/method_not_missing) [![Gem Version](https://badge.fury.io/rb/method_not_missing.svg)](http://badge.fury.io/rb/method_not_missing)

Implements missing methods on the fly by googling their implementation
on rubydoc.info. Because Ruby.

Intance variables are added when needed and missing classes are also
declared at runtime.

There's some backtracking if the implementation found raises an error
(like stack overflows) or if a nested method lookup fails.

# Installation

```sh
gem install method_not_missing
```

## External dependencies

- PhantomJS ( `brew install phantomjs` on OSX )

# Example

```ruby
require "method_not_missing"

object = MethodNotMissing::OmnipotentObject.new
object.update([3])
## Googling...
#=> [3]
object.update([4])
#=> [3, 4]
object.inspect
#=> #<MethodNotMissing::OmnipotentObject:70308021738440 @uncounted=[3, 4]>
```

# Future work:

- Type Safety: since we get the arity of the requested function, we
  could filter out the ones with the wrong number of argument. This is
  implemented with exception-driven backtracking on ArgumentErrors
  right now.

- Enterprise

## Contributing

1. Fork it ( https://github.com/[my-github-username]/method_not_missing/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
