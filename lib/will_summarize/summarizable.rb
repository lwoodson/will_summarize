module WillSummarize
  class SummarizableException < Exception
  end

  module Summarizable
    def self.extended(base)
      unless base.ancestors.include? ActiveRecord::Base
        raise SummarizableException, "Can only be extended by descendant of ActiveRecord::Base"
      end
    end

    def summarize(attribute)
      if attribute.nil?
        raise SummarizableException, "Attribute cannot be nil"
      end
      if not columns_hash.has_key? attribute.to_s
        raise SummarizableException, "Attribute \"#{attribute}\" not found in model"
      end
      column = columns_hash[attribute.to_s]
      summary_column = columns_hash["summary"]
      if column.type != :string and column.type != :text
        raise SummarizableException, "Summary target must be of string or text type"
      end
      columns = columns_hash.values.select{|column| column.name != attribute.to_s}.map{|column| column.name} 
      scope :summaries, select(columns)

      define_method(:populate_summary) do
        summary = content = send(attribute.to_sym)
        if content.size > summary_column.limit
          # TODO this should be refactored to support other first paragraph
          # matching strategies (plaintext, rdoc, other markups, etc...)
          match_data = /(<p.*?>.*?<\/p>)/m.match(content)
          if match_data
            summary = match_data[1].split().join(" ").sub(/ </, "<").sub(/> /, ">")
            if summary.size > summary_column.limit
              summary = summary[0..(summary_column.limit-8)]
              summary << '...</p>'
            end
          end
        end
        self.summary = summary
      end

      before_save :populate_summary, :if => "summary.blank?"
    end
  end
end
