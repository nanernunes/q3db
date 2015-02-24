module Q3DB
  module Bots
    def bots
      YAML::load File.open('config/bots.yml')
    end

    def world
      "<world>"
    end
  end
end
