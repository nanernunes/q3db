class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :sv_hostname
      t.integer :sv_minRate
      t.integer :sv_maxRate
      t.integer :sv_dlRate
      t.integer :sv_minPing
      t.integer :sv_maxPing
      t.integer :sv_floodProtect
      t.integer :dmflags
      t.integer :fraglimit
      t.integer :timelimit
      t.integer :sv_maxclients
      t.integer :g_maxGameClients
      t.integer :capturelimit
      t.string :version
      t.string :protocol
      t.string :com_protocol
      t.integer :g_gametype
      t.string :mapname
      t.integer :sv_privateClients
      t.integer :sv_allowDownload
      t.integer :bot_minplayers
      t.string :gamename
      t.string :g_needpass
      t.string :Administrator
      t.string :Email
      t.string :URL
      t.string :Location
      t.string :CPU
      t.string :mappack

      t.timestamps :null => false
    end
  end
end
