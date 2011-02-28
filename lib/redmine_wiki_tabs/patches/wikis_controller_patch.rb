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
          # expecting to do something here in the future.
          # ...

          edit_without_wiki_tabs
        end
      end
    end
  end
end
