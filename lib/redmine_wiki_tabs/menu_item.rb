module RedmineWikiTabs
  class MenuItem < Redmine::MenuManager::MenuItem
    attr_reader :title

    def initialize(wiki_tab)
      super(wiki_tab.name.parameterize, 
            {:controller => 'wiki', :action => 'show', :id => wiki_tab.title}, 
            :param => :project_id,
            :caption => wiki_tab.name)

      @title = wiki_tab.title
    end
  end
end
