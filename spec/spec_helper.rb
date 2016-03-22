# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/default.rb'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.order = 'random'
end

def fauxhai_data(platform = 'windows', version = '2012R2')
  ::Fauxhai::Mocker.new(platform: platform, version: version).data
end

def init_node(hash = {})
  ::Chef::Node.new.tap { |node| hash.each { |k, v| node.normal[k] = v } }
end

SUPPORTED_MAJOR_VERSIONS = [2, 3, 4].freeze

FAUXHAI_WINDOWS_VERSIONS = {
  '8' => { arch: %w(x86 x64), core: false, server: false },
  '8.1' => { arch: %w(x86 x64), core: false, server: false },
  '10' => { arch: %w(x86 x64), core: false, server: false },
  '2003R2' => { arch: %w(x86 x64), core: false, server: true },
  '2008R2' => { arch: %w(x64), core: true, server: true },
  '2012' => { arch: %w(x64), core: true, server: true },
  '2012R2' => { arch: %w(x64), core: true, server: true },
}.freeze