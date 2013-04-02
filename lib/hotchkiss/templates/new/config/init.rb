
Dir["#{HK::Application.root}/code/lib/**/*.rb"].each { |file| require file }
Dir["#{HK::Application.root}/code/app/**/*.rb"].each { |file| require file }

# Add your custom requires.
#
# require HK::Application.root + '/a/path'

