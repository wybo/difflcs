require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/sshpublisher'
require File.join(File.dirname(__FILE__), 'lib', 'diff_l_c_s', 'version')

PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_NAME      = 'difflcs'
PKG_VERSION   = DiffLCS::VERSION::STRING + PKG_BUILD
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"

RELEASE_NAME  = "REL #{PKG_VERSION}"

RUBY_FORGE_PROJECT = "difflcs"
RUBY_FORGE_USER    = "wybo"

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
Rake::TestTask.new { |t|
  t.libs << "test"
  t.pattern = 'test/*_test.rb'
  t.verbose = true
  t.warning = false
}

# Generate the RDoc documentation
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "Diff Longest Common Substring -- The diff sniffing out every move"
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.rdoc_files.include('README.txt', 'CHANGELOG.txt')
  rdoc.rdoc_files.include('lib/diff_l_c_s.rb')
  rdoc.rdoc_files.include('lib/diff_l_c_s/*.rb')
}

# Create compressed packages
spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = PKG_NAME
  s.summary = "Diffing that sniffs out moved text."
  s.description = %q{A diff algoritm using longest common substrings that can also find text that has moved.}
  s.version = PKG_VERSION

  s.author = "Wybo Wiersma"
  s.email = "wybo@logilogi.org"
  s.rubyforge_project = "difflcs"
  s.homepage = "http://difflcs.rubyforge.org"

  s.add_dependency('positionrange', '>= 0.6.0' + PKG_BUILD)

  s.has_rdoc = true
  s.requirements << 'none'
  s.require_path = 'lib'

  s.files = [ "Rakefile", "install.rb", "README.txt", "CHANGELOG.txt", "LICENSE.txt" ]
  s.files = s.files + Dir.glob( "lib/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
  s.files = s.files + Dir.glob( "test/**/*" ).delete_if { |item| item.include?( "\.svn" ) }
end
  
Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Publish the docs, gem, and release files"
task :deploy => [:release, :pdoc] do       
  puts 'Published gem'
end

desc "Publish the API documentation"
task :pdoc => [:rdoc] do
  sh "rsync -azv --no-perms --no-times doc/*" +
      " rubyforge.org:/var/www/gforge-projects/difflcs"
end

desc "Publish the release files to RubyForge."
task :release => [ :package ] do
  require 'rubyforge'
  require 'rake/contrib/rubyforgepublisher'

  packages = %w( gem tgz zip ).collect{ |ext| "pkg/#{PKG_NAME}-#{PKG_VERSION}.#{ext}" }

  rubyforge = RubyForge.new.configure
  rubyforge.login
  rubyforge.add_release(PKG_NAME, PKG_NAME, "REL #{PKG_VERSION}", *packages)
end
