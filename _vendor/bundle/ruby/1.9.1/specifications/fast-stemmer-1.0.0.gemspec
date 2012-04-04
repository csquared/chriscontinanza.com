# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fast-stemmer}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Shterenzon"]
  s.date = %q{2009-11-18}
  s.description = %q{Fast Porter stemmer based on a C version of algorithm}
  s.email = %q{romanbsd@yahoo.com}
  s.extensions = ["ext/extconf.rb"]
  s.files = ["test/fast_stemmer_test.rb", "ext/extconf.rb"]
  s.homepage = %q{http://github.com/romanbsd/fast-stemmer}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Fast Porter stemmer based on a C version of algorithm}
  s.test_files = ["test/fast_stemmer_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
