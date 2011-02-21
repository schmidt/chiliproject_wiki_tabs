class WikiTab < ActiveRecord::Base
  belongs_to :project
  named_scope :active, :conditions => {:active => true}

  validates_presence_of :title
  validates_format_of :title, :with => /^[^,\.\/\?\;\|\:]*$/

  validates_presence_of :name
end
