#
# Cookbook Name:: ms_dotnet
# Library:: version_helper
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
module MSDotNet
  class VersionHelper

    attr_reader :arch, :nt_version, :is_core, :is_server, :machine_type

    def initialize(node)
      @arch = node['kernel']['machine'] == 'x86_64' ? 'x64' : 'x86' 
      @nt_version = ::Windows::VersionHelper.nt_version(node)
      @is_core ::Windows::VersionHelper.core_version?(node)
      @is_server ::Windows::VersionHelper.server_version?(node)

      if core?
        @machine_type = :core
      elsif server?
        @machine_type = :server
      else
        @machine_type = :workstation
      end
    end

    def self.factory(node, major_version)
      case major_version
        when 2
          V2Helper.new node
        when 4
          V4Helper.new node
        else
          raise ArgumentError
      end
    end

    def features(version)
      version_features.include?(version) ? all_features : []
    end

    def package(version)
       all_packages[version] if version_package.include? version
    end

    def patches(version)
      version_patches.include?(version) ? all_patches[version] : []
    end

    protected

    def all_features
      raise NotImplementedError
    end

    def all_packages
      raise NotImplementedError
    end

    def all_patches
      raise NotImplementedError
    end

    def core?
      is_core
    end

    def server?
      is_server
    end

    def x64?
      arch == 'x64' 
    end
  end
end