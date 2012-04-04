# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "term-ansicolor"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = "2010-03-11"
  s.description = ""
  s.email = "flori@ping.de"
  s.executables = ["cdiff", "decolor"]
  s.extra_rdoc_files = ["README"]
  s.files = ["bin/cdiff", "bin/decolor", "README"]
  s.homepage = "http://flori.github.com/term-ansicolor"
  s.rdoc_options = ["--main", "README", "--title", "Term::ANSIColor"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "term-ansicolor"
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby library that colors strings using ANSI escape sequences"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
