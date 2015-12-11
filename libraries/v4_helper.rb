#
# Cookbook Name:: ms_dotnet
# Library:: v4_helper
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
  class V4Helper
    def packages
      {
        '4.0' => {
          name:     'Microsoft .NET Framework 4 Extended',
          url:      'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
          checksum: '65e064258f2e418816b304f646ff9e87af101e4c9552ab064bb74d281c38659f',
        },
        '4.5' => {
          name:     'Microsoft .NET Framework 4.5',
          url:      'http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_x86_x64.exe',
          checksum: 'a04d40e217b97326d46117d961ec4eda455e087b90637cb33dd6cc4a2c228d83',
        },
        '4.5.1' => {
          name:     'Microsoft .NET Framework 4.5.1',
          url:      'http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
          checksum: '5ded8628ce233a5afa8e0efc19ad34690f05e9bb492f2ed0413508546af890fe',
        },
        '4.5.2' => {
          name:      'Microsoft .NET Framework 4.5.2',
          url:       'http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe',
          checksum:  '6c2c589132e830a185c5f40f82042bee3022e721a216680bd9b3995ba86f3781',
          
        }
        '4.6' => {
          name:      'Microsoft .NET Framework 4.6',
          url:       'http://download.microsoft.com/download/C/3/A/C3A5200B-D33C-47E9-9D70-2F7C65DAAD94/NDP46-KB3045557-x86-x64-AllOS-ENU.exe',
          checksum:  'b21d33135e67e3486b154b11f7961d8e1cfd7a603267fb60febb4a6feab5cf87',
        },
      }.tap do |packages|
        # .NET 4.5.2 is installed as an update on 2012 & 2012R2
        if nt_version.between? 6.2, 6.3
          hotfix_id = nt_version == 6.3 ? 'KB2934520' : 'KB2901982'
          packages['4.5.2'][:not_if] = "wmic QFE where HotFixID'#{hotfix_id}' | FindStr #{hotfix_id}"
        end
      end
    end

    def patches
      {
        'KB2468871' => {
          name:      'Update for Microsoft .NET Framework 4 Extended (KB2468871)',
          url:       "http://download.microsoft.com/download/2/B/F/2BF4D7D1-E781-4EE0-9E4F-FDD44A2F8934/NDP40-KB2468871-v2-#{arch}.exe",
          checksum:  x64? ? 'b1b53c3953377b111fe394dd57592d342cfc8a3261a5575253b211c1c2e48ff8' : '8822672fc864544e0766c80b635973bd9459d719b1af75f51483ff36cfb26f03',
        },
        'KB3083186' => {
          name:      'Update for Microsoft .NET Framework 4.6 (KB3083186)',
          url:       "https://download.microsoft.com/download/3/E/C/3EC59EE9-5699-4159-9691-E04E38D677CC/NDP46-KB3083186-#{arch}.exe",
          checksum:  x64? ? 'bf850afc7e7987d513fd2c19c9398d014bcbaaeb1691357fa0400529975edace' : '41e675937d023828d648c7a245e19695ed12f890c349d8b6f2b620e6e58e038e',
          not_if:    'reg query "HKLM\SOFTWARE\Microsoft\Updates\Microsoft .NET Framework 4.6\KB3083186" | FindStr /Ec:"ThisVersionInstalled +REG_SZ +Y"',
        },
      } 
    end

    def setup_modes
      case nt_version
        when 5.1, 5.2 # Windows XP & Windows Server 2003
          { package: ['4.0'] }
        when 6.0, 6.1 # Vista, 7 & Windows Server 2008, 2008R2
          { package: ['4.0', '4.5', '4.5.1', '4.5.2', '4.6'] }
        when 6.2 # Windows 8 & Server 2012
          { feature: ['4.0', '4.5'], package: ['4.5.1', '4.5.2', '4.6'] }
        when 6.3 # Windows 8.1 & Server 2012R2
          { feature: ['4.0', '4.5', '4.5.1'], package: ['4.5.2', '4.6'] }
        when 10 # Windows 10
          { feature: ['4.0', '4.5', '4.5.1', '4.5.2'], package: ['4.6'] }
        else
          {}
      end
    end

    def feature_names
      case nt_version
        when 6.2, 6.3, 10
          case machine_type
            # TODO check 2012R2 Core feature name
            when :core
              ['netFx4-Server-Core']
            when :server
              ['NetFx4ServerFeatures']
            else
              ['NetFx4']
          end
      end
    end
  end
end