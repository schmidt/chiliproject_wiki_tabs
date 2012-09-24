require 'redmine'

Redmine::Plugin.register :wiki_tabs do
  name 'ChiliProject Wiki Tabs Plugin'
  author 'Gregor Schmidt'
  description 'This plugin provides the ability to add tabs linking to wiki ' +
              'pages on a per-project basis.'

  version WikiTabs::Version.full
  url 'http://github.com/finnlabs/redmine_wiki_tabs'
  author_url 'http://www.finn.de/'

  unless Redmine::AccessControl.allowed_actions(:edit_wiki_pages).include? 'wiki/new'
    Redmine::AccessControl.modules_permissions('wiki').find { |p| p.name == :edit_wiki_pages }.actions << 'wiki/new'
    Redmine::AccessControl.modules_permissions('wiki').find { |p| p.name == :edit_wiki_pages }.actions << 'wiki/new_child'
    Redmine::AccessControl.modules_permissions('wiki').find { |p| p.name == :edit_wiki_pages }.actions << 'wiki/create'
  end
end

require 'dispatcher'
Dispatcher.to_prepare :wiki_tabs do
  require_dependency 'wiki_tab'

  require_dependency 'wiki_tabs/patches/wiki_patch'
  require_dependency 'wiki_tabs/patches/wiki_controller_patch'
  require_dependency 'wiki_tabs/patches/redmine_menu_manager_patch'
  require_dependency 'wiki_tabs/patches/active_record_errors_patch'
end
