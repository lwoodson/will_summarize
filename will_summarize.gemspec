Gem::Specification.new do |s|
  s.name = "will_summarize"
  s.version = "0.0.1"
  s.date = "2012-04-22"
  s.summary = "Support for summaries of large text fields in ActiveRecord"
  s.description = "Allows large text fields in ActiveRecord models to be " +
                  "summarized and fetched efffiently for list view"
  s.authors = ["Lance Woodson"]
  s.email = "lance@webmaneuvers.com"
  s.files = ["lib/will_summarize.rb"]
  s.homepage = "http://github.com/lwoodson/will_summarize"
  s.add_runtime_dependency "active_record", [">= 3.1.0"]
  s.add_development_dependency "rspec"
end
