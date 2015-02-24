require 'quakeentry'
require 'match'
require 'client'

describe Client do

  before :each do
    Match.create
    Q3DB::QuakeEntry.new '0:02 ClientConnect: 1'
  end

  after :each do
    Match.destroy_all
    Client.destroy_all
  end

  it "should create a client connection on the last match" do
    expect( Client.count ).to be_eql 1
  end

  it "should change the nickname of the previous connected client" do
    Q3DB::QuakeEntry.new '0:09 ClientUserinfoChanged: 1 n\Bones\t\0\model\bones/bones\tl\0'
    expect( Client.last.nickname ).to be_eql "Bones"
    expect( Client.last.model ).to be_eql "bones/bones"
  end

end
