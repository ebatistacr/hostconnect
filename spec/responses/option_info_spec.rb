require File.dirname(__FILE__) + "/../spec_helper"

describe HostConnect::OptionInfo do
  it "should have means for displaying number of hits from a hotel search" do
    @response = File.read("./spec/fixtures/responses/option_info/hotel_search.xml")
    option_info = OptionInfo.new(@response)
    option_info.size.should == 9
  end
  
  it "should be possible to display the last element" do
    @response = File.read("./spec/fixtures/responses/option_info/hotel_search.xml")
    option_info = OptionInfo.new(@response)
    last = option_info.last
    last.opt.should == "LONACCUMLONSTDBCB"
  end
  
  it "should be possible to display the first element" do
    @response = File.read("./spec/fixtures/responses/option_info/hotel_search.xml")
    option_info = OptionInfo.new(@response)
    first = option_info.first
    first.opt.should == "LONACHOINKCSTDBEB"
  end
  
  it "should be possible to read stay results" do
    @response = File.read("./spec/fixtures/responses/option_info/hotel_price.xml")
    option_info = OptionInfo.new(@response).first
    option_info.opt.should == "BERACBERGRABB"
    option_info.option_number.should == 4772
    option_info.stay_results.availability.should == "RQ"
    option_info.stay_results.currency.should == "EUR"
    option_info.stay_results.total_price.should == 348
  end
  
  it "should be possible to read rates" do
    @response = File.read("./spec/fixtures/responses/option_info/hotel_search.xml")
    option_info = OptionInfo.new(@response).first
    option_info.rates.currency.should == "GBP"
    option_info.rates.rate.room_rates.single_rate.should == 120
  end
  
  it "should be possible to read general info" do
    @response = File.read("./spec/fixtures/responses/option_info/tours.xml")
    option_info = OptionInfo.new(@response).first
    option_info.general.comment.should == "Cat2/Start Oslo"
    option_info.general.description.should == "Norway in a Nutshell"
    option_info.general.periods.should == 5
  end
end
