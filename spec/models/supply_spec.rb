require 'spec_helper'
require 'quakeentry'
require 'match'
require 'client'
require 'supply'
require 'item'

describe Supply do
	
	before :each do
		Match.create
		QuakeEntry.new '0:02 ClientConnect: 3'
	end

	after :each do
		Match.destroy_all
		Client.destroy_all
		Supply.destroy_all
		Item.destroy_all
	end

	it "should create an item and associate it to a player" do
		QuakeEntry.new '0:00 Item: 3 weapon_shotgun'

		client_id = Client.where(:session_id => 3).last.id
		last_item = Item.where(:item => 'weapon_shotgun').last.id

		expect( Item.where(:item => 'weapon_shotgun').count ).to be_eql 1
		expect( Supply.where(:item_id => last_item).last.client_id ).to be_eql client_id
	end

end