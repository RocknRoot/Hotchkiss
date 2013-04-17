module Cli

  TEMPLATE_DIR = Gem::Specification.find_by_name("hotchkiss").gem_dir +
                     "/lib/hotchkiss/templates/"
  DB_INFOS = YAML::load(File.open(Dir.pwd + "/config/db.yml"))
  MG_DIR = Dir.pwd + "/code/app/models/migrations/"

end ## Cli
