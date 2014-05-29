require_relative '../spec_helper'

describe Match do
	
	before :all do
		@match = Match.create
	end

	after :all do
		Match.destroy_all
	end

end