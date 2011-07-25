# encoding: utf-8
module KingDta
  class Booking
    include KingDta::Helper

    # Die am häufigsten benötigten Textschlüssel
    LASTSCHRIFT_ABBUCHUNG            = '04000'
    LASTSCHRIFT_EINZUGSERMAECHTIGUNG = '05000'
    UEBERWEISUNG_GUTSCHRIFT          = '51000'

    attr_accessor :value, :currency, :account, :text, :account_key, :payment_type
    #Eine Buchung ist definiert durch:
    #- Konto (siehe Klasse Konto
    #- Betrag
    #  Der Betrag kann , oder . als Dezimaltrenner enthalten.
    #- Währung
    #  Als 3-stelligen ISO Code (z.B. 'EUR' <- default)
    #- optional Buchungstext
    def initialize( account, value, currency='EUR', text=nil, account_key=nil )
      raise Exception.new("Hey, a booking should have an Account") unless account.kind_of?( Account )
      @account = account
      @text = text ? convert_text( text ) : text
      @account_key = account_key
      if value.is_a?(String)
        value = BigDecimal.new value.sub(',', '.')
      elsif value.is_a?(Numeric)
        value = BigDecimal.new value.to_s
      else
        raise Exception.new("Gimme a value as a String or Numeric. You gave me a #{value.class}")
      end
      value = ( value * 100 ).to_i  #€-Cent
      if value == 0
        raise Exception.new("A booking of 0.00 € makes no sence")
      elsif value > 0
        @value = value
        @pos   = true
      else
        @value = -value
        @pos   = false
      end
      @currency = currency.upcase
    end

    def text=(text)
       @text = convert_text( text )
    end

    def pos?; @pos end

  end  #class Buchung
end  #module dtaus
