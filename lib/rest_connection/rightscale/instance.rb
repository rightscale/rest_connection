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

# This is an instance facing api and can only be used with
# an authentication URL normally found in the instance's userdata called
# RS_API_URL
module RestConnection::RightScale
  class Instance
    include RestConnection::RightScale::Api::Base
    extend RestConnection::RightScale::Api::BaseExtend
    include RestConnection::RightScale::Api::Taggable
    extend RestConnection::RightScale::Api::TaggableExtend
    #def create_ebs_volume_from_snap(snap_aws_id)
    #  connection.post('create_ebs_volume.js', :aws_id => snap_aws_id )
    #end

    def attach_ebs_volume(params)
      connection.put('attach_ebs_volume.js', params)
    end

    def create_ebs_snapshot(params)
      connection.post('create_ebs_snapshot.js', params)
    end

    def detach_ebs_volume(params)
      connection.put('detach_ebs_volume.js', params)
    end

    def delete_ebs_volume(params)
      connection.delete('delete_ebs_volume.js', params)
    end

    def create_ebs_volume(params)
      connection.post('create_ebs_volume.js', params)
    end
  end
end