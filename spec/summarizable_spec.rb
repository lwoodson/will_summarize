require "spec_helper"

describe "WillSummarize" do
  before :all do
    class Post < ActiveRecord::Base
      summarize :content
      validates :summary, :length => {:maximum => 34}
    end

    class SummaryOnlyPost < ActiveRecord::Base
      summarize :content, :filter => lambda {|column| false}
    end
  end

  describe "test environment" do
    it "should have connection established to test database" do
      ActiveRecord::Base.connection.execute("select time()").should_not == nil
    end

    it "should have a Post model class defined" do
      lambda {Post.first}.should_not raise_exception
    end
  end

  describe "will_summarize" do
    it "should add summarize method to ActiveRecord::Base" do
      ActiveRecord::Base.respond_to?(:summarize).should == true
    end
  end

  describe "Summarizable.summarize" do
    it "should not allow a nil attribute arg" do
      lambda { ActiveRecord::Base.summarize nil }.should
        raise_exception(WillSummarize::SummarizableException)
    end

    it "should not allow a non-existant column to be passed in" do
      lambda do
        class BadPost < ActiveRecord::Base
          summarize :foo
        end
      end.should raise_exception(WillSummarize::SummarizableException)
    end

    it "should not accept column argument to non string or text column" do
      lambda do
        class Widget < ActiveRecord::Base
          summarize :price
        end
      end.should raise_exception(WillSummarize::SummarizableException)
    end

    describe "Model.summaries scope" do
      it "should be added automagically to correctly declared models" do
        post = Post.new :title => "test title", 
                        :content => "this is a test",
                        :summary => "summary"
        post.save!
        summary = Post.summaries[0]
        summary.title.should == "test title"
        summary.summary.should == "summary"
        lambda{summary.content}.should raise_exception(ActiveModel::MissingAttributeError)
      end
      
      it "should allow columns to be filtered out with filter option" do
          post = SummaryOnlyPost.new :title => "test", :content => "this is a test"
          post.save!
          summary = SummaryOnlyPost.summaries[0]
          summary.summary.should == "this is a test"
          lambda {summary.content}.should raise_exception(ActiveModel::MissingAttributeError)
          lambda {summary.title}.should raise_exception(ActiveModel::MissingAttributeError)
      end
    end

    describe "Summarizable.populate_summary" do
      it "should populate summary with full content if content is less than the summary limit" do
        post = Post.new :title => "test",
                        :content => "This is a test"
        post.populate_summary
        post.summary.should == post.content
      end

      it "should populate summary with first paragraph of content" do
        post = Post.new :title => "test",
                        :content => '<h1>test</h1><p class="blah">This is a test</p><p>It is only a test.</p>'
        post.populate_summary
        post.summary.should == '<p class="blah">This is a test</p>'
      end

      it "should truncate long summary and append ..." do
        post = Post.new :title => "test",
                        :content => '<p class="blah">This is a really big test.  Not really.</p>'
        post.populate_summary
        post.valid?.should == true
        post.summary.should == '<p class="blah">This is a r...</p>'
      end

      it "should allow paragraph content to span multiple lines" do
        post = Post.new :title => "test",
                        :content => <<-MLS
                          <p>
                            this content
                            spans lines
                          </p>
                        MLS
        post.populate_summary
        post.valid?.should == true
        post.summary.should == '<p>this content spans lines</p>'
      end

      it "should be invoked for records with nil summaries on save" do
        post = Post.new :title => "test", :content => "this is a test"
        post.save!
        post.summary.should == "this is a test"
      end

      it "should be invoked for records with blank summaries on save" do
        post = Post.new :title => "test", :content => "this is a test", :summary => ""
        post.save!
        post.summary.should == "this is a test"
      end

      it "should not be invoked for records with populated summaries on save" do
        post = Post.new :title => "test", :content => "this is a test", :summary => "a"
        post.save!
        post.summary.should == "a"
      end

      
    end
  end
end
