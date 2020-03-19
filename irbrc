require "irb/completion"
require "rubygems"
require "pp"

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:USE_READLINE] = true
IRB.conf[:AUTO_INDENT] = true

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  class ActiveRecord::Base
    delegate :inspect, to: :attributes
  end
end
