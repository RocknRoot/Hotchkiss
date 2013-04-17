require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'tilt'
require 'sequel'
require 'hotchkiss'

HK::Application.root = ::File.expand_path(::File.dirname(__FILE__))
require HK::Application.root + '/config/init'

run HK::Application.burnbabyburn!
