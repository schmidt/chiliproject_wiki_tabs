ActionController::Routing::Routes.draw do |map|
  map.wiki_new       'projects/:project_id/wiki/new',           :controller => 'wiki', :action => 'new'
  map.wiki_new_child 'projects/:project_id/wiki/:id/new', :controller => 'wiki', :action => 'new_child'
  map.wiki_create    'projects/:project_id/wiki',     :controller => 'wiki', :action => 'create', :conditions => { :method => :post }
end
