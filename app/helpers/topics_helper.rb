# TO DO  => review UX
module TopicsHelper
  def topic_button_color(state)
    if state == 'closed'
      return ['green', "check_circle"]
    else
      return ['orange', 'pause_circle_filled']
    end
  end

  def state_button_tag(state, options={})
    icon_attr = topic_button_color(state)
    color = icon_attr.first
    picto = icon_attr.last
    content_tag(:i, picto, class: "material-icons #{color} #{options[:class]}")
  end
end
