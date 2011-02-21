module RedmineWikiTabs
  module Patches
    module WikisControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods
          InstanceMethods.alias_methods(base)
        end
      end

      module InstanceMethods
        def self.alias_methods(base)
          base.send(:alias_method_chain, :edit, :wiki_tabs)
        end

        def edit_with_wiki_tabs
          @project.attributes = params[:project]
          if request.post?
            @project.save 
            # remove delete marker from tabs, that were not actually delete.
            # otherwise, the _destroy input would be set silently, which leads
            # to unexpected ui behavior
            @project.wiki_tabs.select(&:marked_for_destruction?).each do |t|
              t.instance_variable_set(:@marked_for_destruction, false)
            end
          end

          if params[:wiki][:start_page].blank?
            # wikis always need a start page, but we are removing that need.
            # what should we do? remove the requirement or work around it,
            # by faking the user interaction and making it work.
          end

          edit_without_wiki_tabs
        end
      end
    end
  end
end
