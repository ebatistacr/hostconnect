# This file begins the loading sequence.
pwd = File.dirname(__FILE__)

# This line just let's us require anything in the +lib+ sub-folder
# without specifying a full path.
$LOAD_PATH.unshift(pwd)

require "rubygems"
require "bundler/setup"

# Require dependencies
%w[net/https builder date time ostruct hpricot rtf
   active_support yaml logger].each { |lib| require lib }

# Require HostConnect files
%w[client response builder rtf_document translation
   coercion].each { |lib| require "#{pwd}/hostconnect/#{lib}" }

Dir.glob("#{pwd}/hostconnect/builders/*.rb").each { |file| require file }
Dir.glob("#{pwd}/hostconnect/responses/*.rb").each { |file| require file }
Dir.glob("#{pwd}/hostconnect/core_extensions/*.rb").each { |file| require file }

module HostConnect
  extend self

  def setup(env, config)
    config[:dtd] =
      'http://217.115.61.41:8080/iCom/hostConnect_' + config[:version] + '.dtd'
    @@config = OpenStruct.new config

    log_level = case env
                when :test         then Logger::WARN
                when :development  then Logger::DEBUG
                when :production   then Logger::ERROR
                else               raise ArgumentError, 'Incorrect environment: ' + env.to_s
                end

    log_path = config[:log_path] || "log/"
    @@logger = Logger.new(log_path + env.to_s + ".log")
    @@logger.level = log_level
    @@logger.formatter = Logger::Formatter.new
    @@logger.datetime_format = "%Y-%d-%m %H:%M:%S"
  end

  def config
    @@config
  end

  def logger
    @@logger
  end
end
