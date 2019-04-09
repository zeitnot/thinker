# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thinker/version'

Gem::Specification.new do |spec|
  spec.name          = 'thinker'
  spec.version       = Thinker::VERSION
  spec.authors       = ['Mehmet Yildiz']
  spec.email         = ['mehmet.iu@gmail.com']

  spec.summary       = ' This gem compares local data of Campaign entity and the corresponding remote data. '
  spec.description   = ' This gem compares local data of Campaign entity and remote data  '
  spec.homepage      = 'https://github.com/zeitnot/thinker'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/zeitnot/thinker'
    spec.metadata['changelog_uri'] = 'https://github.com/zeitnot/thinker'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.15'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'reek', '~> 5.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.49.0'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-console', '~> 0.4'
  spec.add_development_dependency 'webmock', '~> 3.5'
  spec.add_development_dependency 'yard', '~> 0.9'
end
