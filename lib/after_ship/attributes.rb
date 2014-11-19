class AfterShip
  # Extracted attributes loading.
  module Attributes
    # Loop through the data hash and for each key call a setter with the value.
    #
    # @param data [Hash]
    def load_attributes(data)
      data.each do |attribute, value|
        setter = "#{ attribute }="
        send(setter, value) if respond_to?(setter)
      end
    end
  end
end
