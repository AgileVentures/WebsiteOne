
Rails.application.config.middleware.use OmniAuth::Builder do
  # TODO register for a proper authentication key https://github.com/settings/applications
  provider :github, '992af46d7af9fbc6f551', 'fb8967ce60af9f2b2b4ba4bc5e9da8ed31d04d22'
  provider :gplus, '831357382296', 'XI2snnzxl2YR8queiG5YAbHo'
end
