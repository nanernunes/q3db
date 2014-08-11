require 'quaketrace'

class PersistenceObserver < ActiveRecord::Observer

  observe :match, :score, :client, :supply, :chat

  def after_create object

    case object
        when Match  then $counter.init
        when Score  then $counter.kill_up
        when Chat   then $counter.chat_up
        when Client then $counter.join_up
        when Supply then $counter.item_up
    end

    QuakeTrace.new( $counter ).notice

  end
end