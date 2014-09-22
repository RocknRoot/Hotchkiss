module Cli

  class Generate < Thor

    desc "model NAME", "Generate model files."
    def model(name)
      name = init(name)
      file = Dir.pwd + "/code/app/models/#{name}.rb"
      unless Dir.exists?(Cli::MODEL_DIR)
        Dir.mkdir(Cli::MODEL_DIR)
      end
      open(file, File::CREAT|File::TRUNC|File::RDWR) do |f|
        f << "class #{name.capitalize} < Sequel::Model\nend\n"
      end
      migration(name)
      puts "Creation: #{file}"
    end

    desc "controller NAME", "Generate controller files."
    def controller(name)
      name = init(name)
      file = Dir.pwd + "/code/app/controllers/#{name}_controller.rb"
      open(file, File::CREAT|File::TRUNC|File::RDWR) do |f|
        f << "class #{name.capitalize}Controller < HK::Controller\nend\n"
      end
      puts "Creation: #{file}"
    end

    desc "migration NAME", "Generate migration file."
    def migration(name)
      name = init(name)
      timestamp = Time.now.to_i
      final_name = "#{timestamp}_#{name}"
      file = Dir.pwd + "/db/migrations/#{final_name}.rb"
      FileUtils.cp_r(Cli::TEMPLATE_DIR + "generate/migration/migration", file)
      puts "Creation: #{file}"
    end

    no_tasks do

      def init(name)
        unless File.exists?(Cli::MG_DIR)
          abort("#{Cli::MG_DIR} directory doesn't exist, did you create your app ?\nPlease use 'hk new [app_name] to create it.")
        end
        return name.downcase
      end

    end

  end # Generate

end ## Cli
