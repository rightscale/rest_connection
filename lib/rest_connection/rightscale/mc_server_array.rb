#--
# Copyright (c) 2010-2012 RightScale Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

#
# You must have Beta v1.5 API access to use these internal API calls.
#
module RestConnection::RightScale
  class McServerArray
    include RestConnection::RightScale::Api::Gateway
    extend RestConnection::RightScale::Api::GatewayExtend
    include RestConnection::RightScale::Api::McTaggable
    extend RestConnection::RightScale::Api::McTaggableExtend

    def resource_plural_name
      "server_arrays"
    end

    def resource_singular_name
      "server_array"
    end

    def self.resource_plural_name
      "server_arrays"
    end

    def self.resource_singular_name
      "server_array"
    end

    def self.parse_args(deployment_id=nil)
      (deployment_id ? "deployments/#{deployment_id}/" : "")
    end

    def self.filters
      [:deployment_href, :name]
    end

    # TODO
  end
end