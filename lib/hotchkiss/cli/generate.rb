module Cli

  class Generate < Thor

    desc "model NAME", "Generate model files."
    def model(name)
      puts name
    end

    desc "controller NAME", "Generate controller files."
    def controller(name)
      puts name
    end

    desc "migration NAME", "Generate migration file."
    def migration(name)
      timestamp = Time.now.to_i
      final_name = "#{timestamp}_#{name}"
      unless File.exists?(Cli::MG_DIR)
        abort("#{Cli::MG_DIR} directory doesn't exist, did you create your app ?\nPlease use 'hk new [app_name] to create it.")
      end
      FileUtils.cp_r(Cli::TEMPLATE_DIR + "generate/migration/migration", Dir.pwd + "/db/migrations/#{final_name}.rb")
    end

  end # Generate

end ## Cli
