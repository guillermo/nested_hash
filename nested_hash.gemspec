# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "nested_hash/version"

Gem::Specification.new do |s|
  s.name        = "nested_hash"
  s.version     = NestedHash::VERSION
  s.authors     = ["Guillermo Álvarez"]
  s.email       = ["guillermo@cientifico.net"]
  s.homepage    = ""
  s.summary     = %q{Convert a simple one level hash to a multilevel hash}
  s.description = %q{For example a hash like { "properties.age" => 3 } will be converted into { "properties" => {"age" => 3}} }

  s.rubyforge_project = "nested_hash"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
