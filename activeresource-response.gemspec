# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_resource_response/version"

Gem::Specification.new do |s|
  
  s.name        = "activeresource-response"
  s.version     = ActiveResourceResponse::Version::VERSION
  s.authors     = ["Igor Fedoronchuk"]
  s.email       = ["fedoronchuk@gmail.com"]
  s.homepage    = "https://github.com/didww/activeresource-response"
  s.summary     = %q{activeresource extension}
  s.description = %q{This gem adds possibility to access http response object from result of ActiveResource::Base find method }
  s.license     = 'MIT'

  s.add_runtime_dependency('activeresource', ['>= 6.1', '< 6.2'])
  s.add_dependency "jruby-openssl" if RUBY_PLATFORM == "java"
  s.add_development_dependency "minitest"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'byebug'


  s.files         = `git ls-files | sed '/.gitignore/d'`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
