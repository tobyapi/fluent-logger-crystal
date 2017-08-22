require "./logger/*"

module Fluent::Logger
  extend self

  def new(*args)
    typ = if args.first.is_a?(LoggerBase)
      args.shift
    else
      FluentLogger
    end
    typ.new(*args)
  end

  def open(*args)
    close
    @@default_logger = new(*args)
  end

  def close
    if @@default_logger
      @@default_logger.close
      @@default_logger = nil
    end
  end

  def post(tag,map)
    default.post(tag,map)
  end

  def default
    @@default_logger ||= ConsoleLogger.new(IO::Memory.new)
  end

  def default=
    @@default_logger = logger
  end
end
