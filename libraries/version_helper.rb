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

  def self.version_helper(node, major_version)
    case major_version
      when 2
        V2Helper.new node
      when 3
        V3Helper.new node
      when 4
        V4Helper.new node
      else
        fail ArgumentError
    end
  end

  class VersionHelper < PackageHelper
    def features(version)
      version_features.include?(version) ? all_features : []
    end

    def package(version)
      packages[version] if version_package.include? version
    end

    def patches(version)
      version_patches.include?(version) ? packages[version] : []
    end

    protected
    def version_features
      fail NotImplementedError
    end

    def version_patches
      fail NotImplementedError
    end

    def setup_mode
      fail NotImplementedError
    end

    def supported_version
      fail NotImplementedError
    end
  end
end
