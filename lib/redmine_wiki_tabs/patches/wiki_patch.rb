module RedmineWikiTabs
  module Patches
    module WikiPatch
      def self.included(base)
        base.class_eval do
          has_many :tabs, :class_name => 'WikiTab', :dependent => :destroy, :order => 'name'
          accepts_nested_attributes_for :tabs, 
            :allow_destroy => true,
            :reject_if => proc { |attr| attr['name'].blank? && attr['title'].blank? }

          include InstanceMethods
        end
      end

      module InstanceMethods
        def validate
          if !show_default_tab && self.errors.on(:start_page)
            self.errors.clear('start_page')
          end
        end
      end
    end
  end
end
