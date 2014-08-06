class QuakeEntry

  require 'quakecount'

  def initialize(entry)

    case entry

      # 0:00 InitGame: \sv_hostname\QUAKE EXTREME BRASIL\sv_minRate\0\sv_maxRate\10000 ...
      when /(\d+:\d+)[ ]?InitGame: \\(.*)/
		#QuakeCount::init
		Match.create Hash[*$2.split('\\')]


      # 33:17 Kill: 1 0 7: Daemia killed Xaero by MOD_ROCKET_SPLASH
      when /(\d+:\d+)[ ]?Kill: (\d+) (\d+) (\d+): (.*) killed (.*) by (\w+)$/

		Client.where({:match_id => Match.last.id, :session_id => $2, :nickname => $5})
	  		.first_or_create if $5.eql?("<world>")

		Score.create ({
		  :match_id   => Match.last.id,
		  :elapsed    => $1.to_quakeseconds,
		  :killer_id  => Client.where(:match_id => Match.last.id, :session_id => $2).last.id,
		  :killed_id  => Client.where(:match_id => Match.last.id, :session_id => $3).last.id,
		  :weapon_id  => Weapon.where(:weapon => $7, :id => $4).first_or_create.id
		})

		#QuakeCount::kill_up


      # 4:03 say: Xaero: The hawk or the wolf? One works in concert, the other, alone.
      when /(\d+:\d+)[ ]?say: (.*)/

		Client.where(:match_id => Match.last.id).map(&:nickname).uniq.compact.each do |n|

		  if ($2.start_with?(n))

		    Chat.create ({
		      :elapsed  => $1.to_quakeseconds,
		      :match_id => Match.last.id,
		      :nickname => n,
		      :message  => $2.split("#{n}: ", 2).last
		    })

		    break

		  end

		end

		#QuakeCount::chat_up


      # 3:52 score: 0  ping: 48  client: 2 ^9OVERFLOW^2-AF	
      when /(\d+:\d+)[ ]?score: (\d+)  ping: (\d+)  client: (\d+) (.*)/


      # 0:00 ClientConnect: 0
      when /(\d+:\d+)[ ]?ClientConnect: (\d+)/
		Client.create ({
		  :match_id   => Match.last.id,
		  :elapsed    => $1.to_quakeseconds,
		  :session_id => $2
		})

		#QuakeCount::join_up


      # 0:00 ClientUserinfoChanged: 2 n\^9IFMATCH^2-BR\t\0\model\bones/bones\hmodel\sarge\g_redteam\\g_blueteam\\c1\4\c2\5\hc\100\w\0\l\0\tt\0\tl\0
      when /(\d+:\d+)[ ]?ClientUserinfoChanged: (\d+) (.*\d)$/

		client_info = Hash[*$3.split('\\')]

		Client.update(
		  Client.where(:match_id => Match.last.id, :session_id => $2).last.id, {
		    :elapsed    => $1.to_quakeseconds,
		    :nickname   => client_info["n"],
		    :model      => client_info["model"]
		  }
		)


      # 0:00 ClientBegin: 0
      when /(\d+:\d+)[ ]?ClientBegin: (\d+)/
	   #Client.update (
	   #  Client.where(:match_id => Match.last.id, :session_id => $2).last.id,
	   #  :elapsed    => $1,
	   #  :through    => true
	   #)


      # 0:00 ClientDisconnect: 0
      when /(\d+:\d+)[ ]?ClientDisconnect: (\d+)/
	   #Client.update (
	   #  Client.where(:match_id => Match.last.id, :session_id => $2).last.id,
	   #  :elapsed    => $1,
	   #  :through    => false
	   #)


      # 0:00 Item: 0 weapon_shotgun
      when /(\d+:\d+)[ ]?Item: (\d+) (\w+)$/
		Supply.create ({
		  :match_id   => Match.last.id,
		  :elapsed    => $1.to_quakeseconds,
		  :client_id  => Client.where(:match_id => Match.last.id, :session_id => $2).last.id,
		  :item_id    => Item.where(:item => $3).first_or_create.id
		})

		#QuakeCount::item_up

    end

  end

end  