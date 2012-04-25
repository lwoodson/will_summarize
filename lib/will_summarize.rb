require "will_summarize/summarizable"

module WillSummarize
end

class ActiveRecord::Base
  extend WillSummarize::Summarizable
end

