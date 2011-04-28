ActionController::Routing::Routes.draw do |map|
  map.wiki_new       'projects/:project_id/wiki/new',     :controller => 'wiki', :action => 'new',    :conditions => { :method => :get }
  map.wiki_create    'projects/:project_id/wiki/new',     :controller => 'wiki', :action => 'create', :conditions => { :method => :post }
  map.wiki_new_child 'projects/:project_id/wiki/:id/new', :controller => 'wiki', :action => 'new_child', :conditions => { :method => :get }
end
