require 'yaml'

module Cli

  DB_INFO_FILE = Dir.pwd + "/config/db.yml"

  TEMPLATE_DIR = Gem::Specification.find_by_name("hotchkiss").gem_dir +
                     "/lib/hotchkiss/templates/"
  DB_INFOS = YAML::load(File.open(DB_INFO_FILE)) if File.exists?(DB_INFO_FILE)
  MG_DIR = Dir.pwd + "/db/migrations/"
  MODEL_DIR = Dir.pwd + "/code/app/models"

  ERROR_DB_INFOS_FILE_MSG = 'Did you configure your config/db.yml file ?'
end ## Cli
