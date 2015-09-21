#
# Author:: Chef Partner Engineering (<partnereng@chef.io>)
# Copyright:: Copyright (c) 2015 Chef Software, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module OracleCloud
  class Orchestration < Asset
    def local_init
      @asset_type = 'orchestration'
    end

    def status
      asset_data['status']
    end

    def description
      asset_data['description']
    end

    def start
      client.asset_put(asset_type, "#{name_with_container}?action=START")
      refresh
    end

    def stop
      client.asset_put(asset_type, "#{name_with_container}?action=STOP")
      refresh
    end

    def delete
      client.asset_delete(asset_type, name_with_container)
    end
  end
end
