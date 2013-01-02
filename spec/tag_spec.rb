require 'rubygems'
require 'rest_connection'
require 'ruby-debug'

describe RestConnection::RightScale::Tag, "tags" do
  it "a server" do
    mytags = ["provides:rs_blah=blah"]
    search = ["provides:rs_blah"]
    #mytags = ["blah", "blah2"]
    s = RestConnection::RightScale::Server.find(:first)
    t = RestConnection::RightScale::Tag.set(s.href, mytags)
    t.response.code.should == "204"
    f = RestConnection::RightScale::Tag.search("server", mytags)
    f.size.should > 0
    t2 = RestConnection::RightScale::Tag.unset(s.href, mytags)
    t2.response.code.should == "204"
  end
end
