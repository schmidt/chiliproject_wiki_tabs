require 'redmine'

Redmine::Plugin.register :redmine_wiki_tabs do
  name 'Redmine Wiki Tabs Plugin'
  author 'Gregor Schmidt'
  description 'This plugin provides the ability to add tabs linking to wiki ' +
              'pages on a per-project basis.'
  version '0.0.1'
  url 'http://github.com/finnlabs/redmine_wiki_tabs'
  author_url 'http://www.finn.de/'
end

require 'dispatcher'
Dispatcher.to_prepare :redmine_wiki_tabs do

  require_dependency 'project'
  unless Project.included_modules.include?(RedmineWikiTabs::Patches::ProjectPatch)
    Project.send(:include, RedmineWikiTabs::Patches::ProjectPatch)
  end

  require_dependency 'wikis_controller'
  unless WikisController.included_modules.include?(RedmineWikiTabs::Patches::WikisControllerPatch)
    WikisController.send(:include, RedmineWikiTabs::Patches::WikisControllerPatch)
  end
end

