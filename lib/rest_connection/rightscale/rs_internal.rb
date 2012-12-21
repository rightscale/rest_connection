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
# You must have special API access to use these internal API calls.
#
class RsInternal
  include RightScale::Api::Base
  extend RightScale::Api::BaseExtend
  extend ::RightScale::Api::InternalConnection

  def connection
    self.connection
  end

  def self.connection
    # call connection defined in InternalConnection module
    super
  end

  def self.get_server_template_multi_cloud_images(server_template_href)
    connection.get("rs_internal/get_server_template_multi_cloud_images","server_template_href=#{server_template_href}")
  end

  def self.set_server_multi_cloud_image(server_href, mci_href)
    connection.put("rs_internal/set_server_multi_cloud_image", {:server_href => server_href, :multi_cloud_image_href => mci_href})
  end
end
