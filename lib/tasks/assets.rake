require "fileutils"

namespace :assets do
  desc "Copy npm assets to appropriate locations"
  task :npm do
    sh "npm install"

    # USWDS
    mkdir_p "public/vendor/uswds"
    Dir.glob("node_modules/uswds/dist/*").each do |file|
      cp_r file, "public/vendor/uswds/"
    end

    # Chart.js
    cp "node_modules/chart.js/dist/Chart.js", "vendor/assets/javascripts"
  end
end
