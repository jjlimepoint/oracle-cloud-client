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
  class InstanceRequest
    attr_reader :client, :opts
    def initialize(client, opts)
      @client    = client
      @opts      = opts

      validate_options!

      @name      = opts[:name]
      @shape     = opts[:shape]
      @imagelist = opts[:imagelist]
      @public_ip = opts[:public_ip]
      @label     = opts.fetch(:label, @name)
      @sshkeys   = opts.fetch(:sshkeys, [])
    end

    def validate_options!
      raise "The following required options are missing: #{missing_required_options.join(', ')}" unless
        missing_required_options.empty?

      raise "#{@shape} is not a valid shape" unless client.shapes.exist?(@shape)
      raise "#{@imagelist} is not a valid imagelist" unless client.imagelists.exist?(@imagelist)
      raise 'sshkeys must be an array of key names' unless @sshkeys.respond_to?(:each)
    end

    def missing_required_options
      [ :name, :shape, :imagelist ].each_with_object([]) do |opt, memo|
        memo << opt unless opts[opt]
      end
    end

    def full_name
      client.compute_identity_domain + '/' + client.username + '/' + @name
    end

    def nat
      return unless @public_ip
      (@public_ip == :pool) ? 'ippool:/oracle/public/ippool' : "ipreservation:#{@public_ip}"
    end

    def networking
      networking = {}
      networking['nat'] = nat unless nat.nil?
    end

    def to_h
      {
        'shape'     => @shape,
        'label'     => @label,
        'imagelist' => @imagelist,
        'name'      => full_name,
        'sshkeys'   => @sshkeys
      }
    end
  end
end
