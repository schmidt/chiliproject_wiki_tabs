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

  require_dependency 'wiki'
  require_dependency 'wiki_controller'
  require_dependency 'wiki_tab'
  unless Wiki.included_modules.include?(WikiTabs::Patches::WikiPatch)
    Wiki.send(:include, WikiTabs::Patches::WikiPatch)
  end
  unless WikiController.included_modules.include?(WikiTabs::Patches::WikiControllerPatch)
    WikiController.send(:include, WikiTabs::Patches::WikiControllerPatch)
  end

  begin
    require_dependency 'redmine/menu_manager/menu_helper'
    WikiTabs::Patches::RedmineMenuManagerPatch.reload_support = true
  rescue LoadError
    WikiTabs::Patches::RedmineMenuManagerPatch.reload_support = false
  end

  unless Redmine::MenuManager::MenuHelper.included_modules.include?(WikiTabs::Patches::RedmineMenuManagerPatch)
    Redmine::MenuManager::MenuHelper.send(:include, WikiTabs::Patches::RedmineMenuManagerPatch)
  end

  unless ActiveRecord::Errors.included_modules.include?(WikiTabs::Patches::ActiveRecordErrorsPatch)
    ActiveRecord::Errors.send(:include, WikiTabs::Patches::ActiveRecordErrorsPatch)
  end
end
