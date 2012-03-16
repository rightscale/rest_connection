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
class Session
  include RightScale::Api::Gateway
  extend RightScale::Api::GatewayExtend

  deny_methods :index, :destroy, :update, :show

  def self.index
    self.new(connection.get(resource_singular_name))
  end

  def self.create(opts={})
    settings = connection.settings
    ignored, account = settings[:api_url].split(/\/acct\//) if settings[:api_url].include?("acct")
    params = {
      "email" => settings[:user],
      "password" => settings[:pass],
      "account_href" => "/api/accounts/#{account}"
    }.merge(opts)
    resp = connection.post(resource_singular_name, params)
    connection.cookie = resp.response['set-cookie']
  end

  def self.accounts(opts={})
    settings = connection.settings
    params = {
      "email" => settings[:user],
      "password" => settings[:pass],
    }.merge(opts)
    a = Array.new
    connection.get(resource_singular_name + "/accounts").each do |object|
      a << Account.new(object)
    end
    return a
  end

  def self.create_instance_session
    # TODO
  end

  def self.index_instance_session
    # TODO
  end
end
