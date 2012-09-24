module WikiTabs
  module Patches
    module WikiPatch
      def self.included(base)
        base.class_eval do
          unloadable

          has_many :tabs, :class_name => 'WikiTab',
                          :dependent => :destroy,
                          :order => 'name'

          accepts_nested_attributes_for :tabs,
            :allow_destroy => true,
            :reject_if => proc { |attr| attr['name'].blank? && attr['title'].blank? }

          safe_attributes :tabs_attributes

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

require_dependency 'wiki'

Wiki.send(:include, WikiTabs::Patches::WikiPatch)
