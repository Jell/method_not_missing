require "method_not_missing/version"
require "method_not_missing/omnipotent_object"
require "method_not_missing/method_searcher"

module MethodNotMissing
  extend self

  def self.included (base)
    base.extend self
  end

  def method_missing (meth, *args)
    result = nil
    puts "Missing: #{meth}"
    args.each { |arg| arg.extend MethodNotMissing rescue nil }
    found = MethodSearcher.search_method(meth.to_s).detect do |method_body|
      begin
        puts "*"*80
        puts method_body
        puts "*"*80

        vars = method_body.scan(/@[a-zA-Z0-9_]+/)
        puts "Vars: #{vars}"
        vars.each do |var|
          # We want a class with << because that's a common method and
          # it can't be found online.
          object = Class.new(Array) { include MethodNotMissing }.new
          instance_variable_get(var) or
            instance_variable_set(var, object)
        end

        self.class.send(:eval, method_body)
        result = self.send(meth, *args) do
          yield
        end
        true
      rescue Exception => e # We wanna rescue stack overflows also
        puts "Error!"
        puts e.inspect
        false
      end
    end

    if found
      result
    else
      super
    end
  end

  def const_missing(name)
    puts "Missing class #{name}"
    puts "making it up on the spot"
    klass = Class.new(OmnipotentObject)
    const_set(name, klass)
    klass
  end
end
