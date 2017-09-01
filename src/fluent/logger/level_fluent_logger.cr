require "logger"
require "./fluent_logger"

module Fluent::Logger
  class LevelFluentLogger < ::Logger
    delegate :close, :reopen, :connect?, to: fluent_logger

    private getter fluent_logger : Fluent::Logger::FluentLogger

    def initialize(
      tag_prefix : String? = nil,
      host = "localhost",
      port = 24224,
      socket_path : String? = nil,
      limit : Int32 = BUFFER_LIMIT,
      @progname = String.empty)
      @level = ::Logger::DEBUG
      @closed = nil
      @mutex = nil
      @formatter = -> (severity, datetime, progname, message){
        map = { level: severity }
        map[:message] = message if message
        map[:progname] = progname if progname
        map
      }
      @fluent_logger = FluentLogger.new(tag_prefix, host, port, socket_path, limit)
    end

    def add(severity, message = nil, progname = nil)
      severity ||= ::Logger::UNKNOWN
      return true if severity < @level
      progname ||= @progname
      if message.nil?
        message = progname
        progname = @progname
      end
      map = format_message(format_severity(severity), Time.now, progname, message)
      @fluent_logger.post(format_severity(severity).downcase, map)
      true
    end

    def add(severity, message = nil, progname = nil, &block)
      severity ||= ::Logger::UNKNOWN
      return true if severity < @level
      progname ||= @progname
      message = yield if message.nil?
      map = format_message(format_severity(severity), Time.now, progname, message)
      @fluent_logger.post(format_severity(severity).downcase, map)
      true
    end
  end
end
