module Q3DB
  module Main
    def self.run!(file)
      loop do

        # Return the last commited value (size / time)
        fsize = ((c = Commit.last).nil? ? 0 : c.fsize)
        mtime = ((c = Commit.last).nil? ? 0 : c.mtime)
       
        sleep 1
       
        # Commits only new contents to database
        unless (file.mtime.to_i.eql?(mtime))
       
          file.seek fsize
          lines = file.each_line.take_while { |l| l.match(/\n/) }
          lines.map { |e| QuakeEntry.new(e) }
       
          Commit.create ({
            :fsize => lines.join.size + fsize,
            :mtime => file.mtime.to_i
          })
       
        end
       
      end
    end
  end
end
