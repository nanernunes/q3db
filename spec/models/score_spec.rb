require 'spec_helper'
require 'quakeentry'
require 'quaketrace'
require 'match'
require 'client'
require 'weapon'
require 'score'

describe Score do
	
	before :each do
		Match.create
		QuakeEntry.new '0:01 ClientConnect: 0'
		QuakeEntry.new '0:02 ClientConnect: 1'
	end

	after :each do
		Match.destroy_all
		Client.destroy_all
		Weapon.destroy_all
		Score.destroy_all
	end

	it "should create a score for a player" do		
		QuakeEntry.new ( '33:17 Kill: 1 0 0: Daemia killed Xaero by MOD_SHOTGUN' )

		@score = Score.last

		expect( @score.killer_id ).to be_eql Client.where(:session_id => 1).last.id
		expect( @score.killed_id ).to be_eql Client.where(:session_id => 0).last.id
		expect( @score.weapon_id ).to be_eql 0
	end

	it "should create a client to <world> events" do
		QuakeEntry.new ( '5:20 Kill: 1022 1 16: <world> killed Xaero by MOD_LAVA' )	
		expect( Client.where(:nickname => '<world>').last.session_id ).to be_eql 1022
	end

	it "should create a new weapon when it doesn't exists" do
		QuakeEntry.new ( '5:20 Kill: 1022 1 16: <world> killed Xaero by MOD_LAVA' )	
		expect( Weapon.where(:weapon => 'MOD_LAVA').count ).to be_eql 1
	end


end
