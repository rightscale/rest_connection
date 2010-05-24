#    This file is part of RestConnection 
#
#    RestConnection is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    RestConnection is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with RestConnection.  If not, see <http://www.gnu.org/licenses/>.

class ServerTemplateInternal 
  include RightScale::Api::Base
  extend RightScale::Api::BaseExtend
  include RightScale::Api::Internal
  extend RightScale::Api::InternalExtend

  def resource_plural_name
    "server_templates"
  end

  def resource_singular_name
    "server_template"
  end

  def self.resource_plural_name
    "server_templates"
  end

  def self.resource_singular_name
    "server_template"
  end

  def add_multi_cloud_image(mci_href)
    t = URI.parse(self.href)
    connection.put(t.path + "/add_multi_cloud_image", :multi_cloud_image_href => mci_href)
  end
  
  def delete_multi_cloud_image(mci_href)
    t = URI.parse(self.href)
    connection.put(t.path + "/delete_multi_cloud_image", :multi_cloud_image_href => mci_href)
  end

  def set_default_multi_cloud_image(mci_href)
    t = URI.parse(self.href)
    connection.put(t.path + "/set_default_multi_cloud_image", :multi_cloud_image_href => mci_href)
  end

  def multi_cloud_images
    t = URI.parse(self.href)
    connection.get(t.path + "/multi_cloud_images")
  end

end