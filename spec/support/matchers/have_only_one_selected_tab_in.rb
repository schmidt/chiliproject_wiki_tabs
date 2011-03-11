Spec::Matchers.define :have_exactly_one_selected_tab_in do |menu|
  match do |actual|
    menu_selector = HTML::Selector.new(selector_for_menu(menu))
    tab_selector = HTML::Selector.new('a.selected')

    html = HTML::Document.new(actual.is_a?(String) ? actual : actual.body)

    menu_matches = menu_selector.select(html.root)
    if menu_matches.size == 1
      tab_matches = tab_selector.select(menu_matches.first)

      tab_matches.size == 1
    else
      false
    end
  end

  match do |actual|
    failure_message(menu, actual) == nil
  end

  failure_message_for_should do |actual|
    failure_message(menu, actual)
  end

  description do
    "have exactly one selected tab in #{menu}"
  end

  failure_message_for_should_not do |actual|
    raise "You should not use this matcher for should_not matches"
  end

  def failure_message(menu, actual)
    menu_selector = HTML::Selector.new(selector_for_menu(menu))
    tab_selector = HTML::Selector.new('a.selected')

    html = HTML::Document.new(actual.is_a?(String) ? actual : actual.body)

    menu_matches = menu_selector.select(html.root)
    if menu_matches.size == 1
      tab_matches = tab_selector.select(menu_matches.first)

      if tab_matches.size == 0
        "Expected to find exactly one selected tab in #{menu}, but found none."
      elsif tab_matches.size > 1
        "Expected to find exactly one selected tab in #{menu}, but found #{tab_matches.size}."
      else
        nil
      end
    else
      "Expected to find #{menu.inspect} in document, but didn't."
    end
  end

  def selector_for_menu(menu)
    case menu
    when :project_menu
      '#main-menu'
    else
      raise ArgumentError, 'Unknown menu identifier'
    end
  end
end
