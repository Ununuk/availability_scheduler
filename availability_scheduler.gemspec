require_relative 'lib/availability_scheduler/version'

Gem::Specification.new do |spec|
  spec.name        = 'availability_scheduler'
  spec.version     = AvailabilityScheduler::VERSION
  spec.authors     = ['Paweł Strącała']
  spec.email       = ['pawel.stracala@gmail.com']

  spec.summary     = 'Availability Scheduler is a gem that allows you to schedule availability for your resources.'
  spec.homepage    = 'https://github.com/Ununuk/availability_scheduler'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  # Additional metadata
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Ununuk/availability_scheduler'
  spec.metadata['changelog_uri'] = 'https://github.com/Ununuk/availability_scheduler/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
