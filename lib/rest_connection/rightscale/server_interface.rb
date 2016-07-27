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

require 'rest_connection/ssh_hax'

class ServerInterface

  def initialize(cid = nil, params = {}, deployment_id = nil)

    if deployment_id
      name = params["nickname"] || params["name"] || params[:nickname] || params[:name]
      @impl = McServer.find_by(:name, deployment_id) { |n| n == name }.first
    else
      @impl = McServer.new(params)
    end
    self
  end

  def create(opts)
    location = connection.post(resource_plural_name, translate_create_opts(opts))
    @impl = McServer.new('href' => location)
    settings
    self
  end

  def name
    nickname
  end

  def inspect
    @impl.inspect
  end

  def self.[](*args)
    begin
      ret = Server[*args]
      raise "" if ret.empty?
    rescue
      ret = McServer[*args]
    end
    return ret
  end

  def nickname
    return @impl.name
  end

  def method_missing(method_name, *args, &block)
    @impl.__send__(method_name, *args, &block)
  end

  def clean_and_translate_server_params(it)
    it.each do |k, v|
      clean_and_translate_server_params(v) if v.is_a?(Hash)
    end
    it.reject! { |k, v| v == nil or v == "" }
    it.each { |k, v| it[k] = translate_href(v) if k.to_s =~ /href/ }
    it
  end

  def translate_create_opts(old_opts, instance_only=false)
    fields = [{"1.0" => [:server_template_href],      "1.5" => [:server_template_href]},
              {"1.0" => [:cloud_id],                  "fn" => :map_cloud_id,  "1.5" => [:cloud_href]},
              {"1.0" => [:ec2_image_href],            "1.5" => [:image_href]},
              {"1.0" => [:ec2_user_data],             "1.5" => [:user_data]},
              {"1.0" => [:instance_type],             "fn" => :map_instance,  "1.5" => [:instance_type_href]},
              {"1.0" => [:ec2_security_groups_href],  "1.5" => [:security_group_hrefs]},
              {"1.0" => [:ec2_ssh_key_href],          "1.5" => [:ssh_key_href]},
              {"1.0" => [:vpc_subnet_href]},
              {"1.0" => [:ec2_availability_zone]},
              {"1.0" => [:pricing]},
              {"1.0" => [:max_spot_price]},
              {                                       "1.5" => [:inputs]},
              {"1.0" => [:multi_cloud_image_href],    "1.5" => [:mci_href, :multi_cloud_image_href]},
              {                                       "1.5" => [:datacenter_href]},
              {                                       "1.5" => [:subnet_hrefs]},
              {"1.0" => [:aki_image_href],            "1.5" => [:kernel_image_href]},
              {"1.0" => [:ari_image_href],            "1.5" => [:ramdisk_image_href]}]

    opts = old_opts.dup
    to = "1.5"
    if instance_only
      ret = {"instance" => {}}
      server = ret["instance"]
    else
      ret = {"server" => {"instance" => {}}}
      ret["server"]["name"] = (opts["name"] ? opts["name"] : opts["nickname"])
      ret["server"]["description"] = opts["description"]
      ret["server"]["deployment_href"] = opts["deployment_href"]
      ret["server"]["instance"]["placement_group_href"] = opts["placement_group_href"]
      server = ret["server"]["instance"]
    end

    fields.each { |hsh|
      next unless hsh[to]
      hsh[to].each { |field|
        vals = opts.select {|k,v|
          [ 
            [ 
              hsh["1.0"] 
            ] + 
            [ 
              hsh["1.5"]
            ] 
          ].flatten.include?(k.to_sym) }
        # IMPORTANT NOTE REGARDING RUBY VERSIONS!
        #
        # In Ruby 1.9.3 the next line of code is required to be written the way it is. Previously, it was written as:
        # vals.flatten! which doesn't work in Ruby 1.9.3.
        #
        # This is because opts is a hash and in Ruby 1.8.7, the select (above) returns an flattened array of
        # key, value pairs but in 1.9.3 it returns a new hash. flatten! does not exist for hashes so that would
        # no longer work in Ruby 1.9.3 and the code had to be changed to vals = vals.flatten to work correctly
        # in both Ruby versions.
        vals = vals.flatten
        vals.compact!
        if hsh["fn"]
          server[field.to_s] = __send__(hsh["fn"], to, opts[vals.first]) unless vals.first.nil?
        else
          server[field.to_s] = opts[vals.first] unless vals.first.nil?
        end
        server.delete("inputs") if server["inputs"] && server["inputs"].empty? # Inputs cannot be empty for 1.5
      }
    }
    clean_and_translate_server_params(ret)
    return ret
  end

  def map_cloud_id(to, val)
    if val.is_a?(String)
      begin
        val = val.split(/\//).last
      rescue Exception => e
      end
    end
    if to == "1.5"
      return "https://my.rightscale.com/api/clouds/#{val}"
    elsif to == "1.0"
      return "#{val}"
    end
  end

  def map_instance(to, val)
    if to == "1.0"
      return val
    end
    val
  end

  def translate_href(old_href)
    if old_href.is_a?(Array)
      new_array = []
      old_href.each { |url| new_array << translate_href(url) }
      return new_array
    else
      href = old_href.dup
      href.gsub!(/ec2_/,'')
      href.gsub!(/\/acct\/[0-9]*/,'')
      return href
    end
  end

  # Since RightScale hands back the parameters with a "name" and "value" tags we should
  # transform them into the proper hash.  This it the same for setting and getting.
  def parameters
    return @impl.inputs
  end

  def inputs
    parameters
  end

  def start
    launch
  end

  def stop
    terminate
  end

  def launch
    return @impl.launch
  end

  def terminate
    return @impl.terminate
  end

  def start_ebs
    return connection.logger("WARNING: Gateway Servers do not support start_ebs. Ignoring.")
  end

  def stop_ebs
    return connection.logger("WARNING: Gateway Servers do not support stop_ebs. Ignoring.")
  end

  # This should be used with v4 images only.
  def run_script(script,opts=nil)
    return connection.logger("WARNING: Gateway Servers do not support run_script. Did you mean run_executable?")
  end

  def attach_volume(params)
    return connection.logger("WARNING: Gateway Servers do not support attach_volume. Ignoring.")
  end

  def wait_for_state(st,timeout=1200)
    if st == "stopped"
      st = "inactive"
    end
    @impl.wait_for_state(st,timeout)
  end

  def save(new_params = nil)
    if new_params
      @impl.settings
      @impl.next_instance.params.merge!(translate_create_opts(new_params, :instance_only)["instance"])
    end
    @impl.save
  end

  def update(new_params = nil)
    save(new_params)
  end
end
