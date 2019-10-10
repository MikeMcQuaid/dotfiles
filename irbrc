require "irb/completion"
require "rubygems"
require "pp"

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb_history"

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  class ActiveRecord::Base
    delegate :inspect, to: :attributes
  end
end
