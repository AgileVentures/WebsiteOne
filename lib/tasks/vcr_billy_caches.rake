# frozen_string_literal: true

namespace :vcr_billy_caches do
  desc 'resets all vcr and billy caches to their default state in current git branch'
  task reset: :environment do
    `rm -rf features/support/fixtures/`
    `git checkout features/support/fixtures/`
  end
end
