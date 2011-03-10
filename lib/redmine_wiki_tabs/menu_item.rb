module RedmineWikiTabs
  class MenuItem < Redmine::MenuManager::MenuItem
    unloadable

    attr_reader :title
    attr_accessor :selected

    def initialize(wiki_tab)
      super(wiki_tab.name.parameterize,
            {:controller => 'wiki', :action => 'show', :id => wiki_tab.title},
            :param => :project_id,
            :caption => wiki_tab.name)

      page = wiki_tab.wiki.find_page(wiki_tab.title)
      @title = page ? page.title : Wiki.titleize(wiki_tab.title)
    end
  end
end
