require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'tilt'
require 'sequel'
require 'hotchkiss'

use Rack::Static,
  :urls => ["/static", "/favicon.ico"],
  :root => "public"

HK::Application.root = ::File.expand_path(::File.dirname(__FILE__))
require HK::Application.root + '/config/init'

run HK::Application.burnbabyburn!
