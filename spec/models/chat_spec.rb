require 'quakeentry'
require 'match'
require 'client'
require 'chat'

describe Chat do
	
	before :each do
		Match.create
		QuakeEntry.new '0:01 ClientConnect: 0'
		QuakeEntry.new '0:02 ClientConnect: 1'
		QuakeEntry.new '0:08 ClientUserinfoChanged: 0 n\Bones\t\0'
		QuakeEntry.new '0:09 ClientUserinfoChanged: 1 n\Xaero\t\0'
	end

	after :each do
		Match.destroy_all
		Client.destroy_all
		Chat.destroy_all
	end

	it "should create a chat entry" do
		QuakeEntry.new '4:03 say: Xaero: The hawk or the wolf? One works in concert, the other, alone.'
		expect( Chat.where(:nickname => 'Xaero').count ).to be_eql 1
	end

end