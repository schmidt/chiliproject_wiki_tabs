module RedmineWikiTabs
  module Patches
    module ApplicationControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          helper :wiki_tabs
        end
      end
    end
  end
end
