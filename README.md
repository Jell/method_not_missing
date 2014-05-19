# Method *not* missing

By including the module `NoMoreMissing`, an object's `method_missing`
will be replaced by googling to rdoc and implemented on the
fly. Instance variables are added where missing and missing constants
are also declared on the fly.

There's some backtracking if the implementation found raises an error
(like stack overflows) or if a nested method lookup fails.

# Future work:

- Type Safety: since we get the arity of the requested function, we
  could filter out the ones with the wrong number of argument. This is
  implemented with exception-driven backtracking on ArgumentErrors
  right now.

- Make it a gem

- Enterprise

# Warnings

This is insane.

# Example

```ruby
class MyInsaneObject
  include NoMoreMissing
end

object = MyInsaneObject.new
res = object.add([])
puts "Response: #{res.inspect}"
puts "Object: #{object.inspect}"
puts "done!"
```
