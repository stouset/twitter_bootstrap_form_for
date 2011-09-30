require File.expand_path('../lib/twitter_bootstrap_form_for/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'twitter_bootstrap_form_for'
  s.version     = TwitterBootstrapFormFor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Stephen Touset' ]
  s.email       = [ 'stephen@touset.org' ]
  s.homepage    = 'http://github.com/stouset/twitter_bootstrap_form_for'
  s.summary     = 'Rails form builder optimized for Twitter Bootstrap'
  s.description = 'A custom Rails FormBuilder that assumes the use of Twitter Bootstrap'
  
  # s.required_rubygems_version = '>= 1.8.0'
  # s.rubyforge_project         = 'twitter_bootstrap_form_for'
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map {|f| f =~ /^bin\/(.*)/ ? $1 : nil }.compact
  s.require_path = 'lib'

  s.add_dependency 'rails', '~> 3'
  s.add_dependency 'haml',  '~> 3'
  # TODO: uncomment the next line
  #  s.add_dependency 'twitter-bootstrap', '~> 1.3'
end
