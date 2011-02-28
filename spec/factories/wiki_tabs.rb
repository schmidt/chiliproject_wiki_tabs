Factory.define :wiki_tab do |wiki_tab|
  wiki_tab.association :wiki, :factory => :wiki

  wiki_tab.active true
  wiki_tab.sequence(:name) {|n| "Tab No. #{n}" }
  wiki_tab.sequence(:title) {|n| "Wiki Title #{n}" }
end

Factory.define :wiki_tab_inactive, :parent => :wiki_tab do |wiki_tab|
  wiki_tab.active false
end
