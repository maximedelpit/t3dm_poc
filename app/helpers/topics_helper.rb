# TO DO  => review UX
module TopicsHelper
  def topic_button_color(state)
    if state == 'closed'
      return ['green', "check_circle"]
    else
      return ['red', 'error_outline']
    end
  end

  def state_button_tag(state)
    icon_attr = topic_button_color(state)
    color = icon_attr.first
    picto = icon_attr.last
    content_tag(:i, picto, class: ["material-icons", color])
  end
end
