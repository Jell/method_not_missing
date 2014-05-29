require 'cgi'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.default_wait_time = 10
Capybara.app_host = "http://www.google.co.uk/"
Capybara.ignore_hidden_elements = false

module MethodNotMissing::MethodSearcher
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
