require 'quakecolor'

module QuakeTrace

  def self.notice counter
    print "\n" if counter.joins.zero?
    print "\r"
    print "#{ I18n.t(:match) }: [ ".bold
    print "#{ I18n.t(:joins) }: #{ counter.joins.to_s.rjust(2, '0').green  } - "
    print "#{ I18n.t(:items) }: #{ counter.items.to_s.rjust(4, '0').blue   } - "
    print "#{ I18n.t(:chats) }: #{ counter.chats.to_s.rjust(3, '0').yellow } - "
    print "#{ I18n.t(:kills) }: #{ counter.kills.to_s.rjust(3, '0').red    } "
    print "]".bold
  end

end