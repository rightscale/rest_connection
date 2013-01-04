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
module RestConnection::Rightscale
  class McImage
    include RestConnection::Rightscale::Api::Gateway
    extend RestConnection::Rightscale::Api::GatewayExtend

    deny_methods :create, :destroy, :update

    def resource_plural_name
      "images"
    end

    def resource_singular_name
      "image"
    end

    def self.resource_plural_name
      "images"
    end

    def self.resource_singular_name
      "image"
    end

    def self.filters
      [:cpu_architecture, :description, :image_type, :name, :os_platform, :resource_uid, :visibility]
    end

    def self.parse_args(cloud_id)
      "clouds/#{cloud_id}/"
    end
  end
end