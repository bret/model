require "model/version"
require 'pp'

class Model
  class << self

    attr_writer :keys, :defaults

    def keys
      @keys ||= []
    end

    def defaults
      @defaults ||= {}
    end

    def inherited(subclass)
      subclass.keys = keys.dup
      subclass.defaults = defaults.dup
    end

    # define a key and an optional block that provides a default value for the key
    def key(symbol, &block)
      keys << symbol unless @keys.include? symbol
      attr_accessor symbol
      defaults[symbol] = block if block
    end
  end

  def initialize(hash={})
    (hash.keys - keys).each do |k|
      block = Proc.new {hash[k]}
      self.class.key(k) {instance_exec(&block)}
    end

    hash.each {|key, v| instance_variable_set "@#{key}", v}
    (self.class.defaults.keys - hash.keys).each do |key|
      block = self.class.defaults[key]
      instance_variable_set("@#{key}", instance_exec(&block))
    end
  end

  def keys
    self.class.keys
  end

  def [] key
    send key
  end

  def eql?(other)
    keys.all? { |k| send(k) == other[k] }
  end
  alias_method :==, :eql?

end
