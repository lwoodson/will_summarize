require "will_summarize/summarizable"

module WillSummarize
end

class ActiveRecord::Base
  extend WillSummarize::Summarizable
end

#begin
#  require 'rails_admin/config/actions'
#  require 'rails_admin/config/actions/base'
#
#  # custom action
#  module RailsAdmin
#    module Config
#      module Actions
#        class PopulateSummary < RailsAdmin::Config::Actions::Base
#          register_instance_option :member? do
#            true
#          end
#
#          register_instance_option :controller do
#            Proc.new do
#              @object.populate_summary
#              flash[:notice] = "Summary updated."
#              redirect_to back_or_index
#            end
#          end
#
#          RailsAdmin::Config::Actions.register self
#        end
#      end
#    end
#  end
#
#rescue LoadError; end

