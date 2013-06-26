module Cli

  class Migrate < Thor

    desc "reset", "migration reset (erase and migration up)"
    def reset
      init
      try_catch_migrate do
        Sequel::Migrator.run(@db, MG_DIR, :target => 0)
        Sequel::Migrator.run(@db, MG_DIR)
      end
    end

    desc "to", "Update migrations (up or down) to VERSION."
    def to
      init
      try_catch_migrate do
        raise "No VERSION was provided" unless  ENV['VERSION']
        version = ENV['VERSION'].to_i
        Sequel::Migrator.run(@db, MG_DIR, :target => version)
      end
    end

    desc "up", "Update migrations to latest available."
    def up
      init
      try_catch_migrate do
        Sequel::Migrator.run(@db, MG_DIR)
      end
    end

    desc "down", "Full migration downgrade (erase all data)."
    def down
      init
      try_catch_migrate do
        Sequel::Migrator.run(@db, MG_DIR, :target => 0)
      end
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

      def try_catch_migrate
        begin
          yield
        rescue NoMethodError => e
          puts "Migration error:"
          puts "Do you have some migration defined ?"
          abort "You can have error with the name of your migration (timestamp_name.rb) - Avoid '-' character."
        rescue Sequel::Migrator::Error, Exception => e
          puts "Migration error:"
          abort e.message
        end
      end

    end

  end # Migrate

end ## Cli
