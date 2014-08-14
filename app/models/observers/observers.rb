require 'quaketrace'

class PersistenceObserver < ActiveRecord::Observer

  observe :match, :score, :client, :supply, :chat

  def after_create object

    case object
        when Match  then QuakeCount.instance.startup
        when Score  then QuakeCount.instance.kill_up
        when Chat   then QuakeCount.instance.chat_up
        when Client then QuakeCount.instance.join_up
        when Supply then QuakeCount.instance.item_up
    end

    QuakeTrace::notice QuakeCount.instance

  end
end