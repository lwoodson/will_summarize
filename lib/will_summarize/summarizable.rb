module WillSummarize
  class SummarizableException < Exception
  end

  module Summarizable
    def self.extended(base)
      unless base.ancestors.include? ActiveRecord::Base
        raise SummarizableException, "Can only be extended by descendant of ActiveRecord::Base"
      end
    end

    def summarize(attribute, opts = {})
      column = columns_hash[attribute.to_s]
      summary_column = columns_hash["summary"]
      verify_passed_valid attribute, column
      scope :summaries, select(included_columns(attribute, opts).map{|column| column.name})
      define_populate_summary_for_html_markup attribute, opts, column, summary_column
      before_save :populate_summary, :if => "summary.blank?"
    end

    private
    def verify_passed_valid(attribute, column)
      raise(SummarizableException, "Attribute cannot be nil") if attribute.nil?
      raise(SummarizableException, "Attribute \"#{attribute}\" not found in model") if not columns_hash.has_key? attribute.to_s
      raise(SummarizableException, "Summary target must be of string or text type") if column.type != :string and column.type != :text
    end

    def included_columns(attribute, opts)
      filter = opts[:filter] || lambda {|column| true}
      columns_hash.values.select do |column| 
        if column.name == attribute.to_s
          false
        elsif column.name == "summary"
          true
        else
          filter.call(column)
        end
      end
    end

    def define_populate_summary_for_html_markup(attribute, opts, column, summary_column)
      define_method(:populate_summary) do
        summary = content = send(attribute.to_sym)
        if content.size > summary_column.limit
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
    end
  end
end
