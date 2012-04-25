require 'active_record'
test_dir = File.dirname(__FILE__)

ActiveRecord::Base.configurations = YAML::load(IO.read("#{test_dir}/db/database.yml"))
ActiveRecord::Base.establish_connection("sqlite3")
load(File.join(test_dir, "db", "schema.rb"))
require "will_summarize"
