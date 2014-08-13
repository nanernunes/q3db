require 'quakecolor'

module QuakeTrace

  def self.notice counter
    puts if counter.joins.zero?
    print "\rMatch: [ ".bold
    print "Joins: #{counter.joins.to_s.rjust(2, '0').green } - "
    print "Items: #{counter.items.to_s.rjust(4, '0').blue} - "
    print "Chats: #{counter.chats.to_s.rjust(3, '0').yellow} - "
    print "Kills: #{counter.kills.to_s.rjust(3, '0').red}"
    print " ]".bold
  end

end