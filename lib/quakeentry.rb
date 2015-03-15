module Q3DB
  require 'quake_bots'

  class QuakeEntry
    include Q3DB::Bots

    def initialize( entry )

      case entry

        # 0:00 InitGame: \sv_hostname\QUAKE EXTREME BRASIL\sv_minRate\0\sv_maxRate\10000 ...
        when /(\d+:\d+)[ ]?InitGame: \\(.*)/
          create_match $1, $2

        # 3:17 Kill: 1 0 7: Daemia killed Xaero by MOD_ROCKET_SPLASH
        when /(\d+:\d+)[ ]?Kill: (\d+) (\d+) (\d+): (.*) killed (.*) by (\w+)$/
          create_kill $1, $2, $3, $4, $5, $6, $7

        # 4:03 say: Xaero: The hawk or the wolf? One works in concert, the other, alone.
        when /(\d+:\d+)[ ]?say: (.*)/
          create_chat $1, $2

        # 0:00 ClientConnect: 0
        when /(\d+:\d+)[ ]?ClientConnect: (\d+)/
          create_client $1, $2

        # 0:00 ClientUserinfoChanged: 2 n\^9IFMATCH^2-BR\t\0\model\bones/bones\...tt\0\tl\0
        when /(\d+:\d+)[ ]?ClientUserinfoChanged: (\d+) (.*\d)$/
          update_client $1, $2, $3

        # 0:00 Item: 0 weapon_shotgun
        when /(\d+:\d+)[ ]?Item: (\d+) (\w+)$/
          create_supply $1, $2, $3

        # 0:00 ClientBegin: 0
        when /(\d+:\d+)[ ]?ClientBegin: (\d+)/

        # 0:00 ClientDisconnect: 0
        when /(\d+:\d+)[ ]?ClientDisconnect: (\d+)/

        # 3:52 score: 0  ping: 48  client: 2 ^9OVERFLOW^2-AF
        when /(\d+:\d+)[ ]?score: (\d+)  ping: (\d+)  client: (\d+) (.*)/

      end

    end


    def create_match( elapsed, match_data )
      Match.create Hash[*match_data.split('\\')]
    end

    def create_kill( elapsed, killer_id, killed_id, weapon_id, killer_name, killed_name, weapon_name )
      Client.where({:match_id => Match.last.id, :session_id => killer_id, :nickname => killer_name})
      .first_or_create if killer_name.eql? world

      score = Score.create ({
        :match_id   => Match.last.id,
        :elapsed    => to_quakeseconds(elapsed),
        :killer_id  => Client.where(:match_id => Match.last.id, :session_id => killer_id).last.id,
        :killed_id  => Client.where(:match_id => Match.last.id, :session_id => killed_id).last.id,
        :weapon_id  => Weapon.where(:weapon => weapon_name, :id => weapon_id).first_or_create.id
      })

      Stat.where(:nickname => score.killer.nickname).first_or_create.increment! :winnings unless
      bots.push(world).include? score.killer.nickname or bots.include? score.killed.nickname

      Stat.where(:nickname => score.killed.nickname).first_or_create.increment! :defeats  unless
      bots.include?             score.killer.nickname or bots.include? score.killed.nickname
    end

    def create_chat( elapsed, message )
      Client.where(:match_id => Match.last.id).map(&:nickname).uniq.compact.each do |n|

        if (message.start_with?(n))
          Chat.create ({
            :elapsed   => to_quakeseconds(elapsed),
            :match_id  => Match.last.id,
            :client_id => Client.where(:match_id => Match.last.id, :nickname => n).last.id,
            :nickname  => n,
            :message   => message.split("#{n}: ", 2).last
          })
          break
        end

      end
    end

    def create_client( elapsed, client_id )
      Client.create ({
        :match_id   => Match.last.id,
        :elapsed    => to_quakeseconds(elapsed),
        :session_id => client_id
      })
    end

    def update_client( elapsed, client_id, client_info )
      client_info = Hash[*client_info.split('\\')]

      client = Client.update(
        Client.where(:match_id => Match.last.id, :session_id => client_id).last.id, {
          :elapsed    => to_quakeseconds(elapsed),
          :nickname   => client_info["n"],
          :model      => client_info["model"]
        }
      )

      Stat.where(:nickname => client.nickname).first_or_create
      .increment! :matches unless bots.include? client.nickname
    end

    def create_supply( elapsed, client_id, item_name )
      Supply.create ({
        :match_id   => Match.last.id,
        :elapsed    => to_quakeseconds(elapsed),
        :client_id  => Client.where(:match_id => Match.last.id, :session_id => client_id).last.id,
        :item_id    => Item.where(:item => item_name).first_or_create.id
      })
    end


    private
    def to_quakeseconds time
      min, sec = time.split(':').map(&:to_i)
      ((min * 60) + sec)
    end

  end
end
