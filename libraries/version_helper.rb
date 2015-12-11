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

    def self.factory(node, version)
      case version.to_i
        when 4
          V4Helper.new node
        else
          raise ArgumentError
      end
    end

    def packages
      raise NotImplementedError
    end

    def patches
      raise NotImplementedError
    end

    def setup_modes
      raise NotImplementedError
    end

    def feature_names
      raise NotImplementedError
    end

    protected

    attr_reader :arch, :nt_version, :is_core, :is_server, :machine_type

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