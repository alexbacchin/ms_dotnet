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
  class V3Helper < VersionHelper

    # Catalog of packages, patches and feature
    def version_features
      @feature_names ||= if server? && nt_version >= 6.2
        ['NetFx3ServerFeatures']
      elsif nt_version >= 6.0
        ['NetFx3']
      else
        []
      end
    end

    def setup_mode
      @setup_mode ||= case nt_version
        # Windows XP, Server 2003
        when 5.2, 5.3
          { package: ['3.0', '3.5', '3.5 SP1'] }
        when 6.0
          { feature: ['3.0'], package: ['3.5', '3.5 SP1'] }
        when 6.1, 6.2, 6.3, 10
          { feature: ['3.0', '3.5', '3.5 SP1'] }
      end
    end

    def supported_versions
      @supported_versions ||= ['3.0', '3.5', '3.5 SP1']
    end

    def patch_names
      @patch_names ||= {}
    end
  end
end
