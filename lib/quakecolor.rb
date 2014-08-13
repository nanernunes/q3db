class String

  def colorize(code)
    "\e[#{code}m#{self}\e[0m"
  end

  def black;       colorize(30); end
  def red;         colorize(31); end
  def green;       colorize(32); end
  def yellow;      colorize(33); end
  def blue;        colorize(34); end
  def magenta;     colorize(35); end
  def cyan;        colorize(36); end
  def gray;        colorize(37); end

  def bg_black;    colorize(40); end
  def bg_red;      colorize(41); end
  def bg_green;    colorize(42); end
  def bg_yellow;   colorize(43); end
  def bg_blue;     colorize(44); end
  def bg_magenta;  colorize(45); end
  def bg_cyan;     colorize(46); end
  def bg_gray;     colorize(47); end

  def bold;           "\e[1m#{self}\e[22m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
    
end