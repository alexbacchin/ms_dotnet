#
# Cookbook Name:: ms_dotnet
# Library:: v3_helper
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
  # Provides information about .NET 3 setup
  class V3Helper < VersionHelper
    REGISTRY_KEY_V3 = 'HKLM/Software/Microsoft/Net Framework Setup/NDP/v3.0/'
    REGISTRY_KEY_V35 = 'HKLM/Software/Microsoft/Net Framework Setup/NDP/v3.5/'

    def installed_version
      return unless registry_key_exists? REGISTRY_KEY

      values = Hash[registry_get_values(REGISTRY_KEY).map { |e| [e[:name], e[:data]] }]
      case values[:Release].to_i
        when 0 then '4.0'
        when 378_389 then '4.5'
        when 378_675, 378_758 then '4.5.1'
        when 379_893 then '4.5.2'
        when 393_295, 393_297 then '4.6'
        when 394_254, 394_271 then '4.6.1'
      end if values[:Install].to_i == 1
    end

    def feature_names
      @feature_names ||= nt_version >= 6.0 ? ['NetFx3'] : []
    end

    def feature_setup
      @feature_setup ||= case nt_version
        # Vista, Server 2008
        when 6.0 then ['3.0']
        # 7, 8, 8.1, 10 & Server 2008R2, 2012, 2012R2
        when 6.1, 6.2, 6.3, 10 then ['3.0', '3.5', '3.5.SP1']
        # Other versions
        else []
      end
    end

    def package_setup
      @package_setup ||= case nt_version
        # Windows XP, Server 2003
        when 5.2, 5.3 then ['3.0', '3.5', '3.5.SP1']
        # Vista, Server 2008
        when 6.0 then ['3.5', '3.5.SP1']
        # Other versions
        else []
      end
    end

    def patch_names
      @patch_names ||= {}
    end

    def supported_versions
      @supported_versions ||= ['3.0', '3.5', '3.5.SP1']
    end
  end
end
