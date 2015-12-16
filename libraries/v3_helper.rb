#
# Cookbook Name:: ms_dotnet
# Library:: v2_helper
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
  class V3Helper < VersionHelper

# Catalog of packages, patches and feature

    def all_packages
      @all_packages ||= {
        '3.5.1' => {
          name:       'Microsoft .NET Framework 3.5 Service Pack 1',
          url:        'https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe',
          checksum:   '0582515bde321e072f8673e829e175ed2e7a53e803127c50253af76528e66bc1',
        }
      }
    end

    def all_patches
      # TODO handle theses patches
      # http://www.microsoft.com/en-us/download/details.aspx?id=10006
      # http://www.microsoft.com/en-us/download/details.aspx?id=1055
      # http://www.microsoft.com/en-us/download/details.aspx?id=16211
      # http://www.microsoft.com/en-us/download/details.aspx?id=16921
      @all_patches ||= {} 
    end

    def all_features
      @all_features ||= if server? && nt_version >= 6.2
          ['NetFx3ServerFeatures']
        elsif nt_version >= 6.0
          ['NetFx3']
        else
          []
        end
    end

# Mapping with .NET 3 versions

    def version_features
      @version_features ||= nt_version >= 6.0 ? ['3.5'] : []
    end

    def version_packages
      @version_packages ||= []
    end

    def version_patches
      @version_patches ||= {}
    end
  end
end