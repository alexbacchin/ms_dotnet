#
# Cookbook Name:: ms_dotnet
# Provider:: framework
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright (C) 2015 Criteo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources
provides :ms_dotnet_framework, os: 'windows'

def whyrun_supported?
  true
end

def load_current_resource
  installed_version = version_helper.installed_version

  if installed_version
    @current_resource = ::Chef::Resources::MsDotNetFramework.new new_resource.name, run_context
    @current_resource.version installed_version
  end
end

action :install do
  if features.empty? || package.nil?
    Chef::Log.info "Unsupported .NET version: #{new_resource.version}"
  else
    # Handle features
    features.each do |feature|
      windows_feature feature do
        action        :install
        source        new_resource.feature_source unless new_resource.feature_source.nil?
      end
    end

    # Handle packages
    win_package package if package

    # Handle patches
    if new_resource.include_patches
      patches.each do |patch|
        win_package patch
      end
    end
  end
end

private

def win_package(package)
  windows_package package[:name] do # ~FC009
    action          :install
    installer_type  :custom
    success_codes   [0, 3010]
    options         '/q /norestart'
    timeout         new_resource.timeout
    # Package specific info
    checksum        package[:checksum]
    source          new_resource.package_sources[package[:checksum]] || package[:url]
    not_if          package[:not_if] unless package[:not_if].nil?
  end
end

def major_version
  @major_version ||= new_resource.version.to_i
end

def version_helper
  # Use same design as URI for the factory method
  @version_helper ||= ::MSDotNet.version_helper node, major_version
end

def package
  @package ||= version_helper.package new_resource.version
end

def features
  @features ||= version_helper.features new_resource.version
end

def patches
  @patches ||= version_helper.patches new_resource.version
end
