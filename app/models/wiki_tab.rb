class WikiTab < ActiveRecord::Base
  belongs_to :wiki
  named_scope :active, :conditions => {:active => true}

  validates_presence_of :title
  validates_format_of :title, :with => /^[^,\.\/\?\;\|\:]*$/

  validates_presence_of :name
end
