require 'cucumber/rake/task'
namespace :cucumber do
  Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
    t.cucumber_opts = "--color --tags @wip --wip"
  end
  Cucumber::Rake::Task.new(:ok, 'Run features that should pass') do |t|
    t.cucumber_opts = "--color --tags ~@wip"
  end
end
