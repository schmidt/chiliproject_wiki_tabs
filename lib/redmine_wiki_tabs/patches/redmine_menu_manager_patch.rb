module RedmineWikiTabs
  module Patches
    module RedmineMenuManagerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def menu_items_for_with_wiki_tabs(menu, project = nil, &block)
            if menu == :project_menu && project && project.wiki.present?
              if block.present?
                menu_items_for_without_wiki_tabs(menu, project) do |node|
                  if node.name == :wiki
                    wiki_tabs_menu_items(project, node).each do |wiki_tabs_node|
                      block.call(wiki_tabs_node)
                    end
                  else
                    block.call(node)
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
              menu_items_for_without_wiki_tabs(menu, project, &block)
            end
          end
          alias_method_chain :menu_items_for, :wiki_tabs

          def extract_node_details_with_wiki_tabs(node, project = nil)
            if current_menu_item == :wiki
              caption, url, selected = extract_node_details_without_wiki_tabs(node, project)

              if @page
                if node.is_a?(RedmineWikiTabs::MenuItem)
                  selected = @page.title == node.title
                elsif node.name == :wiki
                  selected = @page.title == @wiki.start_page
                end
              end

              return caption, url, selected

            else
              extract_node_details_without_wiki_tabs(node, project)
            end
          end
          alias_method_chain :extract_node_details, :wiki_tabs

          def wiki_tabs_menu_items(project, wiki_node)
            nodes = []
            nodes << wiki_node if project.wiki.show_default_tab?

            nodes + WikiTab.active.find(:all, :conditions => {:wiki_id => project.wiki}).map do |tab| 
              RedmineWikiTabs::MenuItem.new(tab)
            end
          end
        end
      end
    end
  end
end
