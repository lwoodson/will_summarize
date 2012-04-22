#will_summarize#

Allows large text fields in ActiveRecord models to be summarized and fetched 
efficiently for list view.  The summaries named scope will fetch model
instances without the summarized field (but all others).

###Usage###
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
