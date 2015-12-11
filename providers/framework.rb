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
# TODO: check if a newer version is already installed
end

action :install do
 if have_feature? || have_package?
   # Handle features
   if have_feature?
    feature_source = node['ms_dotnet']["v#{new_resource.major_version}"]['source']
     version_helper.feature_names.each do |feature|
       windows_feature feature do
         action        :install
         source        feature_source unless feature_source.nil?
       end
     end
   end
   # Handle packages
   if have_package?
     package = version_helper.package[version]
     windows_package package[:name] do # ~FC009
       action          :install
       installer_type  :custom
       success_codes   [0, 3010]
       options         '/q /norestart'
       timeout         new_resource.timeout
       # Package specific info
       checksum        package['checksum']
       source          node['ms_dotnet']['packages'][package['checksum']] || package['url']
       not_if          package['not_if'] if package['not_if']
     end
   end

   # Handle patches
   if new_resource.include_patches
    
   end
 else
  Chef::Log.info "Unsupported .NET version: #{new_resource.version}"
 end
end

private

def version_helper
  @version_helper ||= ::MSDotNet::VersionHelper.factory node, new_resource.major_version
end

def setup_modes
  @setup_modes ||= version_helper.setup_modes
end

def have_feature?
  @have_feature ||= setup_modes.feature && setup_modes.feature.include? new_resource.version
end

def have_package?
  @have_package ||= setup_modes.package && setup_modes.package.include? new_resource.version
end