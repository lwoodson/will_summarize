ActiveRecord::Schema.define :version => 0 do
  create_table :posts, :force => true do |t|
    t.column :title, :string
    t.column :content, :text
    t.column :summary, :string, :limit => 34
  end

  create_table :bad_posts, :force => true do |t|
    t.column :title, :string
    t.column :content, :text
    t.column :summary, :string
  end

  create_table :widgets, :force => true do |t|
    t.column :name, :string
    t.column :price, :double
  end

  create_table :summary_only_posts, :force => true do |t|
    t.column :title, :string
    t.column :content, :text
    t.column :summary, :string
  end
end
