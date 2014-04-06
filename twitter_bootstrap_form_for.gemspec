$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "twitter_bootstrap_form_for/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "twitter_bootstrap_form_for"
  s.version     = TwitterBootstrapFormFor::VERSION
  s.authors     = [ 'Stephen Touset', 'Kai Schneider' ]
  s.email       = [ 'stephen@touset.org', 'schneikai@gmail.com' ]
  s.homepage    = 'http://github.com/stouset/twitter_bootstrap_form_for'
  s.summary     = 'Rails form builder optimized for Twitter Bootstrap'
  s.description = 'A custom Rails FormBuilder that assumes the use of Twitter Bootstrap'

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE.markdown", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "bootstrap-datepicker-rails", "~> 1.3"

  s.add_development_dependency "sass-rails", "~> 4.0.0"
  s.add_development_dependency "haml", "~> 4.0.0"
  s.add_development_dependency "haml-rails", "~> 0.4"
  s.add_development_dependency "bootstrap-sass", "~> 3.0.3.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "jquery-rails"
end
