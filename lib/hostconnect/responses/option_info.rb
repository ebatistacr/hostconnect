module HostConnect
  class OptionInfo < AbstractResponse
    include Enumerable

    def size
      @size ||= @data.search("/Reply/OptionInfoReply/Option").size
    end

    private
    def populate
      @elements = []
      @data.search("/Reply/OptionInfoReply/Option").each do |option|
        s = OpenStruct.new
        s.opt = Coercion.from_hc((option/"Opt").innerHTML)
        s.option_number = Coercion.from_hc((option/"OptionNumber").innerHTML)

        general = (option/"OptGeneral")
        unless general.blank?
          r = Struct.new(:description, :comment, :periods).new
          r.description = (general/"Description").first.innerHTML
          r.comment = (general/"Comment").innerHTML
          r.periods = (general/"Periods").innerHTML.to_i

          s.general = r
        end

        stay_results = (option/"OptStayResults")
        unless stay_results.blank?
          r = Struct.new(:availability, :currency, :total_price, :rate_name,
                         :rate_text).new
          r.availability = (stay_results/"Availability").innerHTML
          r.currency = (stay_results/"Currency").innerHTML
          r.total_price = Coercion.price((stay_results/"TotalPrice").innerHTML)
          r.rate_name = (stay_results/"RateName").innerHTML
          r.rate_text = (stay_results/"RateText").innerHTML

          s.stay_results = r
        end

        rates = (option/"OptRates")
        unless rates.blank?
          r = OpenStruct.new
          r.currency = (rates/"Currency").innerHTML

          room_rates = Struct.new(:single_rate, :double_rate, :twin_rate, :triple_rate).new
          room_rates.single_rate = Coercion.price((rates/"RoomRates/SingleRate").innerHTML)
          room_rates.double_rate = Coercion.price((rates/"RoomRates/DoubleRate").innerHTML)
          room_rates.twin_rate = Coercion.price((rates/"RoomRates/TwinRate").innerHTML)
          room_rates.triple_rate = Coercion.price((rates/"RoomRates/TripleRate").innerHTML)

          r.rate = OpenStruct.new
          r.rate.room_rates = room_rates
          s.rates = r
        end

        @elements << s
      end
    end
  end
end
