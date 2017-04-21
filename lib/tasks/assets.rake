require "fileutils"

namespace :assets do
  desc "Copy npm vendor assets to vendor directory"
  task :npm do
    sh "npm install"
    # USWDS
    mkdir_p "vendor/assets/uswds"
    Dir.glob("node_modules/uswds/dist/*").each do |file|
      cp_r file, "vendor/assets/uswds/"
    end
    # Chart.js
    mkdir_p "vendor/assets/chartjs"
    Dir.glob("node_modules/chart.js/dist/*").each do |file|
      cp_r file, "vendor/assets/chartjs"
    end
  end
end
