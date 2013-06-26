module Cli

  class Migrate < Thor

    desc "reset", "migration reset (erase and migration up)"
    def reset
      init
      Sequel::Migrator.run(@db, MG_DIR, :target => 0)
      Sequel::Migrator.run(@db, MG_DIR)
    end

    desc "to", "Update migrations (up or down) to VERSION."
    def to
      init
      version = ENV['VERSION'].to_i
      raise "No VERSION was provided" if version.nil?
      Sequel::Migrator.run(@db, MG_DIR, :target => version)
    end

    desc "up", "Update migrations to latest available."
    def up
      init
      Sequel::Migrator.run(@db, MG_DIR)
    end

    desc "down", "Full migration downgrade (erase all data)."
    def down
      init
      Sequel::Migrator.run(@db, MG_DIR, :target => 0)
    end

    no_tasks do
      def init
        Sequel.extension :migration
        begin
          @db = Sequel.connect(DB_INFOS[:url], DB_INFOS[:options])
        rescue NameError
          puts "Did you configure your config/db.yml file ?"
          abort "Are you in your app directory ?"
        end
      end
    end

  end # Migrate

end ## Cli
