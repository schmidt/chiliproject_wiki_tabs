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

              return caption, url, !!node.selected
            else
              extract_node_details_without_wiki_tabs(node, project)
            end
          end
          alias_method_chain :extract_node_details, :wiki_tabs

          def wiki_tabs_menu_items(project, wiki_node)
            menu_items = WikiTab.active.find(:all, :conditions => {:wiki_id => project.wiki}).map do |tab|
              RedmineWikiTabs::MenuItem.new(tab)
            end

            mark_currently_selected_item(menu_items, wiki_node, project)

            menu_items.unshift wiki_node if project.wiki.show_default_tab?

            menu_items
          end

          def mark_currently_selected_item(menu_items, wiki_node, project)
            return unless current_menu_item == :wiki

            if @page
              menu_items.each do |item|
                item.selected = false
                page = @page

                begin
                  item.selected = true if page.title == item.title
                  page = page.parent
                end while page.present?
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
            end
          end
        end
      end
    end
  end
end
