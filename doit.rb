require 'cgi'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.default_wait_time = 10
Capybara.app_host = "http://www.google.co.uk/"
Capybara.ignore_hidden_elements = false

module NoMoreMissing
  extend self

  def self.included (base)
    base.extend self
  end

  def method_missing (meth, *args)
    result = nil
    puts "Missing: #{meth}"
    args.each { |arg| arg.extend NoMoreMissing rescue nil }
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
          object = Class.new(Array) { include NoMoreMissing }.new
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
    klass = Class.new(Array) do
      include NoMoreMissing
    end
    const_set(name, klass)
    klass
  end

  module MethodSearcher
    extend self

    def search_method (method_name)
      puts "searching #{method_name}"
      @page ||= ::Capybara::Session.new(:poltergeist)
      @page.visit("http://www.google.co.uk/search")
      puts "Googling..."

      @page.fill_in "q", with: "\"def #{method_name}\" site:http://www.rubydoc.info/github"

      @page.click_button "Google Search"

      Enumerator.new do |y|
        links = @page.all("li.g h3").map do |h3|
          h3.find("a")[:href]
        end
        links.each do |url|
          @page.visit url
          html_codes = @page.body.scan(/<pre class="code">.*?<\/pre>/m)
          codes = html_codes.map do |html|
            CGI::unescapeHTML(html.gsub(/<.*?>/,""))
          end
          code = codes.grep(/def #{method_name}/).first
          y << code if code
        end
      end
    end
  end
end

class MyInsaneObject
  include NoMoreMissing
end

object = MyInsaneObject.new
res = object.add([])
puts "Response: #{res.inspect}"
puts "Object: #{object.inspect}"
puts "done!"
