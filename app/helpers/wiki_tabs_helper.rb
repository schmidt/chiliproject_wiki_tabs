module WikiTabsHelper
  def menu_items_for(menu, project = nil)
    if menu == :project_menu && project && project.wiki.present?
      if block_given?
        super do |node|
          if node.name == :wiki
            wiki_tabs_menu_items(project, node).each do |wiki_tabs_node|
              yield(wiki_tabs_node)
            end
          else
            yield(node)
          end
        end
      else
        # calling other branch recursively to avoid code duplication
        nodes = []
        menu_items_for(menu, project) do |node|
          nodes << node
        end
        nodes
      end
    else
      super
    end
  end

  def extract_node_details(node, project = nil)
    if current_menu_item == :wiki
      caption, url, selected = super

      if @page
        if node.is_a?(RedmineWikiTabs::MenuItem)
          selected = @page.title == node.title
        elsif node.name == :wiki
          selected = @page.title == @wiki.start_page
        end
      end

      return caption, url, selected

    else
      super
    end
  end

  def wiki_tabs_menu_items(project, wiki_node)
    nodes = []
    nodes << wiki_node if project.wiki.show_default_tab?

    nodes + WikiTab.active.find(:all, :conditions => {:wiki_id => project.wiki}).map do |tab| 
      RedmineWikiTabs::MenuItem.new(tab)
    end
  end
end
