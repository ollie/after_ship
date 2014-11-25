class AfterShip
  # Gather necessary pieces, assemble a `Typhoeus::Request`, run that,
  # get a `Typhoeus::Response`, parse that, check for errors, return the
  # parse JSON.
  class Request
    # Shorthand for GET request:
    #
    #   request  = Request.new(url: '...', api_key: '...', method: :get)
    #   response = request.response
    #
    # @param  options         [Hash]
    # @option options api_key [String]    Your API key.
    # @option options url     [String]    The full endpoint URL.
    # @option options body    [Hash, nil] Body for the request as a hash.
    #
    # @return [Hash]
    def self.get(options, &block)
      options[:method] = :get
      new(options, &block).response
    end

    # Shorthand for POST request:
    #
    #   request  = Request.new(url: '...', api_key: '...', method: :post)
    #   response = request.response
    #
    # @param  options         [Hash]
    # @option options api_key [String]    Your API key.
    # @option options url     [String]    The full endpoint URL.
    # @option options body    [Hash, nil] Body for the request as a hash.
    #
    # @return [Hash]
    def self.post(options, &block)
      options[:method] = :post
      new(options, &block).response
    end

    # Shorthand for PUT request:
    #
    #   request  = Request.new(url: '...', api_key: '...', method: :put)
    #   response = request.response
    #
    # @param  options         [Hash]
    # @option options api_key [String]    Your API key.
    # @option options url     [String]    The full endpoint URL.
    # @option options body    [Hash, nil] Body for the request as a hash.
    #
    # @return [Hash]
    def self.put(options, &block)
      options[:method] = :put
      new(options, &block).response
    end

    # Prepare the request to be run later.
    #
    # @param  options         [Hash]
    # @option options api_key [String]    Your API key.
    # @option options url     [String]    The full endpoint URL.
    # @option options method  [Symbol]    The HTTP method.
    # @option options body    [Hash, nil] Body for the request as a hash.
    # @param  block           [Proc]      Response modifier callback.
    def initialize(options = {}, &block)
      @api_key = options.fetch(:api_key)
      @url     = options.fetch(:url)
      @method  = options.fetch(:method)
      @body    = options[:body]
      @request = typhoeus_request
      @block   = block
    end

    # Do the request to the server and handle the response.
    def response
      response    = typhoeus_response
      ErrorHandler.precheck(response)
      parsed_body = MultiJson.load(response.body, JSON_OPTIONS)
      ErrorHandler.check(parsed_body.fetch(:meta))

      if @block
        @block.call(parsed_body)
      else
        parsed_body
      end
    end

    protected

    # Run the `Typhoeus::Request` and return the response.
    #
    # @return [Typhoeus::Request]
    def typhoeus_response
      @request.run
    end

    # Make the `Typhoeus::Request` to be run later.
    #
    # @return [Typhoeus::Request]
    def typhoeus_request
      request = Typhoeus::Request.new(
        @url,
        method:  @method,
        headers: {
          'aftership-api-key' => @api_key,
          'Content-Type'      => 'application/json'
        }
      )

      request.options[:body] = MultiJson.dump(@body) if @body
      make_verbose(request) if AfterShip.debug

      request
    end

    # Print the low level cURL internals in the console as well as the
    # request body and response body when it's available.
    #
    # @param request [Typhoeus::Request]
    def make_verbose(request)
      request.options[:verbose] = true

      request.on_complete do |response|
        puts
        puts 'Request body:'
        puts request.options[:body]
        puts
        puts 'Response body:'
        puts response.body
        puts
      end
    end
  end
end
