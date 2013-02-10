require 'yaml'

unless Rails.env.production?
  yaml_data = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'env_vars.yml'))).result)
  APP_CONFIG = HashWithIndifferentAccess.new(yaml_data)
end