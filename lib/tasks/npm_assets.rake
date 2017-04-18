require "fileutils"

namespace :npm do
  desc "Copy npm vendor assets to vendor directory"
  task :assets do
    sh "npm install"
    # USWDS
    mkdir_p "vendor/assets/uswds"
    Dir.glob("node_modules/uswds/dist/*").each do |file|
      cp_r file, "vendor/assets/uswds/"
    end
  end
end
