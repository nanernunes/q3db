class QuakeCount
  include Singleton

  attr_reader :joins, :items, :chats, :kills

  def initialize
    @joins = @items = @chats = @kills = 0
  end

  def startup; initialize ; end
  def join_up; @joins += 1; end
  def item_up; @items += 1; end
  def chat_up; @chats += 1; end
  def kill_up; @kills += 1; end

end