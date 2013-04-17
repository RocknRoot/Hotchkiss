
db = YAML::load(File.open("#{HK::Application.root}/config/db.yml"))
Sequel.connect(db[:url], db[:options])

Dir["#{HK::Application.root}/code/lib/**/*.rb"].each { |file| require file }
Dir["#{HK::Application.root}/code/app/**/*.rb"].each { |file| require file }

