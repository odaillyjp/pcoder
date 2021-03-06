# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'pcoder'
  gem.version       = '1.0.0'
  gem.authors       = ['Suguru Odai']
  gem.email         = ['ourqwers@gmail.com']
  gem.description   = 'Pcoder submits local file to atcoder.'
  gem.summary       = 'Pcoder submits local file to atcoder.'
  gem.homepage      = 'https://github.com/Shindo200/pcoder'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/\Abin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/\A(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.add_dependency 'mechanize'
  gem.add_dependency 'thor'
  gem.add_dependency 'highline'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
