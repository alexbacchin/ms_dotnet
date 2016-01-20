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
  # Factory method to get VersionHelper for a given major .NET version
  def self.version_helper(node, major_version)
    case major_version
      when 2
        V2Helper.new node
      when 3
        V3Helper.new node
      when 4
        V4Helper.new node
      else
        fail ArgumentError, "Unsupported version '#{major_version}'"
    end
  end

  # Base "abstract" class for .NET version helper
  # Provides method to easily determine how to setup a .NET version
  class VersionHelper < PackageHelper
    def initialize(node)
      fail 'MSDotNet::VersionHelper is an "abstract" class and must not be instanciated directly.' if self.class == MSDotNet::VersionHelper
      super
    end

    # Get windows features required by the given .NET version
    def features(version)
      feature_setup.include?(version) ? feature_names : []
    end

    # Get windows package required by the given .NET version
    def package(version)
      packages[version] if package_setup.include? version
    end

    # Get windows patches required by the given .NET version
    def patches(version)
      patch_names[version] || []
    end

    protected

    # Get installed .NET version on the current node
    # Returns a String or nil
    def installed_version
      fail NotImplementedError
    end

    # Get windows feature's names for the major .NET version on the current node OS
    # Returns an Array<string>
    def feature_names
      fail NotImplementedError
    end

    # Get all .NET versions requiring windows feature activation on the current node OS
    # Returns an Array<string>
    def feature_setup
      fail NotImplementedError
    end

    # Get all .NET versions requiring windows package install on the current node OS
    # Returns an Array<string>
    def package_setup
      fail NotImplementedError
    end

    # Get patch package's names for each minor .NET versions on the current node OS
    # Returns a Hash<string,string> with .NET version as key, and package name as value
    def patch_names
      fail NotImplementedError
    end

    # Get all .NET versions supported on the current node OS
    # Returns an Array<string>
    def supported_version
      fail NotImplementedError
    end
  end
end
