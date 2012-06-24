#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.libs << 'lib' << 'test'
end
