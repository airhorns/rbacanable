# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rbacanable}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Nunemaker", "Harry Brundage"]
  s.date = %q{2010-04-07}
  s.description = %q{Simple role based permissions system}
  s.email = %q{harry.brundage@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Changes.rdoc",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "examples/basic.rb",
     "examples/callbacks.rb",
     "examples/roles.rb",
     "lib/canable.rb",
     "lib/canable/actor.rb",
     "lib/canable/canable.rb",
     "lib/canable/cans.rb",
     "lib/canable/enforcers.rb",
     "lib/canable/role.rb",
     "rbacanable.gemspec",
     "specs.watchr",
     "test/helper.rb",
     "test/test_ables.rb",
     "test/test_canable.rb",
     "test/test_cans.rb",
     "test/test_enforcers.rb",
     "test/test_roles.rb"
  ]
  s.homepage = %q{http://github.com/hornairs/rbacanable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Simple role based permissions system}
  s.test_files = [
    "test/helper.rb",
     "test/test_ables.rb",
     "test/test_canable.rb",
     "test/test_cans.rb",
     "test/test_enforcers.rb",
     "test/test_roles.rb",
     "examples/basic.rb",
     "examples/callbacks.rb",
     "examples/roles.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, ["= 2.10.3"])
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, ["= 2.10.3"])
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end

