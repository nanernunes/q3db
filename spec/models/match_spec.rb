require 'quakeentry'
require 'match'

describe Match do

  after :each do
    Match.destroy_all
  end

  it "should create an empty match" do
    Match.create
    expect( Match.count ).to be_eql 1
  end

  it "should parse a match by regex" do
    QuakeEntry.new (
      '0:00 InitGame: \sv_hostname\QUAKE EXTREME BRASIL
      \sv_minRate\0\sv_maxRate\10000\sv_dlRate\100\sv_minPing\0
      \sv_maxPing\0\sv_floodProtect\1\dmflags\0\fraglimit\20\timelimit\0
      \sv_maxclients\8\g_maxGameClients\0\capturelimit\8
      \version\ioq3 1.36 linux-arm Aug  2 2012\com_protocol\71\g_gametype\0
      \mapname\q3dm4\sv_privateClients\0\sv_allowDownload\0\bot_minplayers\0
      \gamename\baseq3\g_needpass\0\Administrator\Naner Nunes\Email
      \naner@naner.com.br\URL\http://q3.naner.us\Location\Brasil
      \CPU\Raspberry-PI $35.00\mappack\http://www.naner.us/quake3.zip'
    )

    @match = Match.last

    expect( @match.sv_hostname ).to be_eql "QUAKE EXTREME BRASIL"

  end
end