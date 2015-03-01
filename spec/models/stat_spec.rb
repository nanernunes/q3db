require 'quakeentry'
require 'match'
require 'client'
require 'weapon'
require 'score'
require 'stat'

describe Stat do

  before :all do
    Match.create
    Q3DB::QuakeEntry.new '0:01 ClientConnect: 0'
    Q3DB::QuakeEntry.new '0:02 ClientConnect: 1'
    Q3DB::QuakeEntry.new '0:03 ClientConnect: 2'
    Q3DB::QuakeEntry.new '0:04 ClientUserinfoChanged: 0 n\Peanut\t\0\model\bones/bones\tl\0'
    Q3DB::QuakeEntry.new '0:05 ClientUserinfoChanged: 1 n\NEWFEAR\t\0\model\bones/bones\tl\0'
    Q3DB::QuakeEntry.new '0:06 ClientUserinfoChanged: 2 n\Xaero\t\0\model\bones/bones\tl\0'
  end

  before :each do
    Stat.destroy_all
  end

  after :all do
    Match.destroy_all
    Client.destroy_all
    Weapon.destroy_all
    Score.destroy_all
    Stat.destroy_all
  end

  it "should create stat to two players" do
    Q3DB::QuakeEntry.new ( '33:17 Kill: 1 0 0: NEWFEAR killed Peanut by MOD_SHOTGUN' )
    expect( Stat.count ).to be_eql 2
    expect( Stat.where(:nickname => 'NEWFEAR').first.winnings ).to be_eql 1
    expect( Stat.where(:nickname => 'NEWFEAR').first.defeats  ).to be_eql 0
    expect( Stat.where(:nickname => 'Peanut' ).first.winnings ).to be_eql 0
    expect( Stat.where(:nickname => 'Peanut' ).first.defeats  ).to be_eql 1
  end

  it "should not create a stat when kill bots" do
    Q3DB::QuakeEntry.new ( '33:17 Kill: 1 2 0: NEWFEAR killed Xaero by MOD_SHOTGUN' )
    expect( Stat.count ).to be_eql 0
  end

  it "should not create a stat when killed by bots" do
    Q3DB::QuakeEntry.new ( '33:17 Kill: 2 0 0: Xaero killed Peanut by MOD_SHOTGUN' )
    expect( Stat.count ).to be_eql 0
  end

  it "should not create a stat called <world> when cratered" do
    Q3DB::QuakeEntry.new ( '5:20 Kill: 1022 0 16: <world> killed Peanut by MOD_LAVA' )
    expect( Stat.count ).to be_eql 1
    expect( Stat.where(:nickname => "<world>").first ).to be_nil
  end

end
