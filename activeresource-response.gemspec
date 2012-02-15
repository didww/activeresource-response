# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activeresource-response/version"

Gem::Specification.new do |s|
  s.name        = "activeresource-response"
  s.version     = ActiveresourceResponse::VERSION
  s.authors     = ["Igor Fedoronchuk"]
  s.email       = ["fedoronchuk@gmail.com"]
  s.homepage    = "https://github.com/Fivell/activeresource-response"
  s.summary     = %q{activeresoure extension}
  s.description = %q{create method for ActiveResource::Base object to access to response }


  s.add_dependency('activeresource', '>= 3.1')

  s.rubyforge_project = "activeresource-response"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
