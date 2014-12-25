require 'erb'
require 'ostruct'
require 'quakecolor'

module QuakeTrace

  def self.notice counter

    puts if counter.joins.zero?

    print ERB.new( File.read(
      File.join('app', 'views', 'trace', 'trace.erb')
    )).result(
      OpenStruct.new( counter.instance_values )
      .instance_eval { binding } ).delete! "\n"

  end

end