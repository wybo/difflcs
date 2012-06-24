# -*- encoding: utf-8 -*-
require File.expand_path('../lib/diff_l_c_s/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Wybo Wiersma"]
  gem.email = ["mail@wybowiersma.net"]
  gem.description = "A resonably fast diff algoritm using longest common substrings that can also detect text that has moved"
  gem.summary = "Diff algoritm that can detect text that has moved"
  gem.homepage = "https://github.com/wybo/diff_l_c_s"
  gem.rubyforge_project = "diff_l_c_s"

  gem.files = `git ls-files`.split($\)
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = "diff_l_c_s"
  gem.require_paths = ["lib"]
  gem.version = DiffLCS::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"

  gem.add_dependency "positionrange"
end
