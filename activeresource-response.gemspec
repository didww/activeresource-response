# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "activeresource-response/version"

Gem::Specification.new do |s|
  s.name        = "activeresource-response"
  s.version     = ActiveresourceResponse::Version::VERSION
  s.authors     = ["Igor Fedoronchuk"]
  s.email       = ["fedoronchuk@gmail.com"]
  s.homepage    = "https://github.com/Fivell/activeresource-response"
  s.summary     = %q{activeresource extension}
  s.description = %q{This gem adds possibility to access http response object from result of ActiveResource::Base find method }


  s.add_dependency('activeresource', '>= 3.0')

  s.rubyforge_project = "activeresource-response"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
