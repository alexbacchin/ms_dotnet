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
  class V2Helper < VersionHelper

# Catalog of packages, patches and feature

    def all_packages
      @all_packages ||= {
        '2.0' => {
          name:     'Microsoft .NET Framework 2.0 Service Pack 2',
          url:      "http://download.microsoft.com/download/c/6/e/c6e88215-0178-4c6c-b5f3-158ff77b1f38/NetFx20SP2_#{arch}.exe",
          checksum: x64? ? '430315c97c57ac158e7311bbdbb7130de3e88dcf5c450a25117c74403e558fbe' : '6e3f363366e7d0219b7cb269625a75d410a5c80d763cc3d73cf20841084e851f',
        },
      }
    end

    def all_patches
      @all_patches ||= {} 
    end

    def all_features
      @all_features ||= if 6.0 == nt_version && machine_type == :server
          ['NET-Framework-Core']
        elsif nt_version.between?(6.0, 6.1) && machine_type == :core
          x64? ? ['NetFx2-ServerCore', 'NetFx2-ServerCore-WOW64'] : ['NetFx2-ServerCore']
        else
          []
        end
    end

# Mapping with .NET 2 versions

    def version_features
      # Windows Vista, 7, Server 2008 & Server 2008R2
      @version_features ||= nt_version.between(6.0, 6.1) ? ['2.0'] : []
    end

    def version_packages
      # Windows XP & Windows Server 2003
      @version_packages ||= nt_version.between(5.1, 5.2) ? ['2.0'] : []
    end

    def version_patches
      @version_patches ||= {}
    end
  end
end