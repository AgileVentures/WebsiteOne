require 'bulk_mailer'

Dir[File.join(Rails.root, "lib", "core_ext", '**', "*.rb")].each {|l| require l }
