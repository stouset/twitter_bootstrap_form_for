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

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map {|f| f =~ /^bin\/(.*)/ ? $1 : nil }.compact
  s.require_path = 'lib'

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sass-rails", "~> 4.0.0"
  s.add_development_dependency "haml", "~> 4.0.0"
  s.add_development_dependency "haml-rails", "~> 0.4"
  s.add_development_dependency "bootstrap-sass", "~> 3.0.3.0"
  s.add_development_dependency "sqlite3"
end
