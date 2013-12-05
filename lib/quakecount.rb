class QuakeCount

  attr_accessor :joins, :items, :chats, :kills

  def initialize
    self.init
  end

  def init
    @joins = @items = @chats = @kills = 0
  end

  def join_up; @joins += 1; end
  def item_up; @items += 1; end
  def chat_up; @chats += 1; end
  def kill_up; @kills += 1; end

end