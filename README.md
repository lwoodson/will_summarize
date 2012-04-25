#Will Summarize#

Allows large text fields in ActiveRecord models to be summarized and fetched 
efficiently for list view.  The summaries named scope will fetch model
instances without the summarized field (but all others).

###Basic Usage###
**Add a summary field to your model via a migration**

```ruby
class AddSummarySupport < ActiveRecord::Migration
  def change
    add_column :summary, :string
  end
end
```

**Declare what fields should be summarized in your model**

```ruby
class Post
  summarize :content
end
```

**Make use of the summaries named scope**

```ruby
Post.summaries.where('publish_date < ?', Time.now)
```
###Summary Autopopulation###
If the summary is blank when saved, it will be populated according to a 
paragraph matching strategy.  Currently, the gem supports html paragraph 
matching, so that the first paragrah including &lt;p&gt; and &lt;/p&gt; is used 
as the summary.  Other strategies will be added in the future.

This is carried out by the populate_summary method added to instances of the
model, and can be invoked anytime you need to repopulate the summary.

###Customizing the columns returned###
By default, the summarized column is not fetched and all other columns are.
You can provide a lambda as a filter that will inspect columns and evaluate to 
true if the column is to be fetched or false otherwise to modify this behavior.
```ruby
class Post
  # filter out any other text columns from objs returned by the summaries scope.
  summarize :content, :filter => lambda {|column| column.type == 'text'}
end
```

###Rails Admin Integration###
TODO


