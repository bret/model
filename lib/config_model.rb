class ConfigModel < Model
  class << self

    # define a key and an optional block that provides a default value for the key
    def key(symbol, &block)
      super
      env_pattern = symbol.to_s.upcase
      defaults[symbol] = Proc.new { ENV[env_pattern] } if ENV[env_pattern]
    end
  end

end
