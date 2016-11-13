# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_resource_response/version"

Gem::Specification.new do |s|
  
  s.name        = "activeresource-response"
  s.version     = ActiveResourceResponse::Version::VERSION
  s.authors     = ["Igor Fedoronchuk"]
  s.email       = ["fedoronchuk@gmail.com"]
  s.homepage    = "http://fivell.github.com/activeresource-response/"
  s.summary     = %q{activeresource extension}
  s.description = %q{This gem adds possibility to access http response object from result of ActiveResource::Base find method }
  s.license     = 'MIT'

  s.add_runtime_dependency('activeresource', ['>= 3', '< 6'])
  s.add_dependency "jruby-openssl" if RUBY_PLATFORM == "java"
  s.add_development_dependency "minitest" , '~> 5.3'
  s.add_development_dependency 'rake', '~> 10'

  s.extra_rdoc_files = %w( README.rdoc )
  s.rdoc_options.concat ['--main', 'README.rdoc']
   

  s.files         = `git ls-files | sed '/.gitignore/d'`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
