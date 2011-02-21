module RedmineWikiTabs
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          has_many :wiki_tabs, :dependent => :destroy
          accepts_nested_attributes_for :wiki_tabs, 
            :allow_destroy => true,
            :reject_if => proc { |attr| attr['name'].blank? && attr['title'].blank? }
        end
      end
    end
  end
end
