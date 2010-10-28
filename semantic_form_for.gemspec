require File.expand_path('../lib/semantic_form_for/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'semantic_form_for'
  s.version     = SemanticFormFor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Stephen Touset' ]
  s.email       = [ 'stephen@touset.org' ]
  s.homepage    = 'http://github.com/stouset/semantic_form_for'
  s.summary     = 'Simple HTML5-enabled form builder'
  s.description = 'A custom Rails FormBuilder that assumes HTML5. Because HTML4 is for chumps.'
  
  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'semantic_form_for'
  
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map {|f| f =~ /^bin\/(.*)/ ? $1 : nil }.compact
  s.require_path = 'lib'
end
