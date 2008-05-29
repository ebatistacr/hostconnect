module HostConnect
  class OptionInfo < AbstractResponse
    include Enumerable
    
    def size
      @data.search("/Reply/OptionInfoReply/Option").size
    end
    
    private
    def populate
      @elements = []
      @data.search("/Reply/OptionInfoReply/Option").each do |option|
        s = OpenStruct.new
        s.opt = (option/"Opt").innerHTML
        s.option_number = Coercion.coerce((option/"OptionNumber").innerHTML)
        
        stay_results = (option/"OptStayResults") 
        unless stay_results.blank?
          r = Struct.new(:availability, :currency, :total_price, :rate_name, :rate_text).new
          r.availability = (stay_results/"Availability").innerHTML
          r.currency = (stay_results/"Currency").innerHTML
          r.total_price = Coercion.coerce((stay_results/"TotalPrice").innerHTML)
          r.rate_name = (stay_results/"RateName").innerHTML
          r.rate_text = (stay_results/"RateText").innerHTML
          s.stay_results = r
        end
       
        @elements << s
      end
      
#      @elements = []
#      @data["OptionInfoReply"][0]["Option"].each do |option|
#        general = {}
#        option["OptGeneral"][0].each { |k,v| general[k.underscore.to_sym] = Coercion.coerce(v) }
#        general[:opt_extras] = nil
#        general[:extra] = {}
#        option["OptGeneral"][0]["OptExtras"][0]["OptExtra"][0].each do |k,v|
#          general[:extra][k.underscore.to_sym] = Coercion.coerce(v)
#        end
#        
#        rates = {}
#        rates[:currency] = option["OptRates"][0]["Currency"]
#        rates[:rate] = option["OptRates"][0]["OptRate"][0]
#        rates[:rate][:room_rates] = option["OptRates"][0]["OptRate"][0]["RoomRates"][0]
#        # ExtrasRates are optional
#        if option["OptRates"][0]["OptRate"][0]["ExtrasRates"]
#          rates[:rate][:extras_rate] = option["OptRates"][0]["OptRate"][0]["ExtrasRates"][0]["ExtrasRate"]
#        end
#        
#        detailed_avails = []
#        option["OptDetailedAvails"][0]["OptDetailedAvail"].each do |o|
#          detailed_avails << { :unit_type => o["UnitType"], :opt_avail => o["OptAvail"] }
#        end
    end
  end
end
