# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Responseのjsonを全てUpperCamelCaseへフォーマットする
Jbuilder.deep_format_keys true
Jbuilder.key_format camelize: :upper
