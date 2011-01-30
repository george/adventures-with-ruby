#!/usr/bin/env ruby
# encoding: UTF-8
require 'bundler'
Bundler.require
require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)
run AdventuresWithRuby::Application
