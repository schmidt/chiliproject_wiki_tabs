require 'redmine'
require 'redmine_activity_module/version'

Redmine::Plugin.register :redmine_wiki_tabs do
  name 'Redmine Wiki Tabs Plugin'
  author 'Gregor Schmidt'
  description 'This plugin provides the ability to add tabs linking to wiki ' +
              'pages on a per-project basis.'

  version RedmineWikiTabs::Version.full
  url 'http://github.com/finnlabs/redmine_wiki_tabs'
  author_url 'http://www.finn.de/'
end

require 'dispatcher'
Dispatcher.to_prepare :redmine_wiki_tabs do

  require_dependency 'wiki'
  require_dependency 'wiki_tab'
  unless Wiki.included_modules.include?(RedmineWikiTabs::Patches::WikiPatch)
    Wiki.send(:include, RedmineWikiTabs::Patches::WikiPatch)
  end

  require_dependency 'redmine/menu_manager/menu_helper'
  unless Redmine::MenuManager::MenuHelper.included_modules.include?(RedmineWikiTabs::Patches::RedmineMenuManagerPatch)
    Redmine::MenuManager::MenuHelper.send(:include, RedmineWikiTabs::Patches::RedmineMenuManagerPatch)
  end

  unless ActiveRecord::Errors.included_modules.include?(RedmineWikiTabs::Patches::ActiveRecordErrorsPatch)
    ActiveRecord::Errors.send(:include, RedmineWikiTabs::Patches::ActiveRecordErrorsPatch)
  end
end
