module RedmineWikiTabs
  module Patches
    module RedmineMenuManagerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          def menu_items_for_with_wiki_tabs(menu, project = nil)
            if menu == :project_menu && project && project.wiki.present?
              if block_given?
                menu_items_for_without_wiki_tabs(menu, project) do |node|
                  if node.name == :wiki
                    wiki_tabs_menu_items(project, node).each do |wiki_tabs_node|
                      yield wiki_tabs_node
                    end
                  else
                    yield node
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
              menu_items_for_without_wiki_tabs(menu, project, &Proc.new)
            end
          end
          alias_method_chain :menu_items_for, :wiki_tabs

          def extract_node_details_with_wiki_tabs(node, project = nil)
            if node.respond_to? :selected
              caption, url, selected = extract_node_details_without_wiki_tabs(node, project)

              return caption, url, node.selected
            else
              extract_node_details_without_wiki_tabs(node, project)
            end
          end
          alias_method_chain :extract_node_details, :wiki_tabs

          def wiki_tabs_menu_items(project, wiki_node)
            menu_items = WikiTab.active.find(:all, :conditions => {:wiki_id => project.wiki}).map do |tab|
              RedmineWikiTabs::MenuItem.new(tab)
            end

            if @page
              menu_items.each do |item|
                item.selected = @page.title == item.title
              end
            end

            if project.wiki.show_default_tab?
              if menu_items.any? &:selected
                def wiki_node.selected
                  false
                end
              else
                def wiki_node.selected
                  true
                end
              end

              menu_items.unshift wiki_node
            end

            menu_items
          end
        end
      end
    end
  end
end
