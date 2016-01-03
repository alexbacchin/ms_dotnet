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

    def setup_mode
      @setup_mode ||= case nt_version
        # Windows XP & Windows Server 2003
        when 5.1, 5.2
          { package: ['2.0 SP2'] }
        # Windows Vista & Server 2008
        when 6.0, 6.1
          { feature: ['2.0 SP2'] }
        else
          {}
      end
    end

    def supported_versions
      @supported_versions ||= ['2.0 SP2']
    end

    # Mapping with .NET 2 versions

    def version_features
      @all_features ||= if 6.0 == nt_version && machine_type == :server
        ['NET-Framework-Core']
      elsif nt_version.between?(6.0, 6.1) && machine_type == :core
        x64? ? ['NetFx2-ServerCore', 'NetFx2-ServerCore-WOW64'] : ['NetFx2-ServerCore']
      else
        []
      end
    end

    def version_patches
      @version_patches ||= {}
    end
  end
end
