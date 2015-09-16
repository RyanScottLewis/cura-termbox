require "pathname"
require "rubygems/package_task"
require "yard"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "reek/rake/task"

gemspec = Pathname.glob(Pathname.new(__FILE__).join("..", "*.gemspec")).first
spec = Gem::Specification.load(gemspec.to_s)

Gem::PackageTask.new(spec) do |task|
  task.need_zip = false
end

YARD::Rake::YardocTask.new

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.patterns = ["lib/**/*.rb"]
  task.formatters = ["fuubar"]
end

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

desc "Mutation testing"
task :mutant do
  exec("mutant --include lib --require cura --use rspec Cura*")
end
