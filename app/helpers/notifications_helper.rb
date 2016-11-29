module NotificationsHelper
  include IconsHelper

  def notification_icon_class(level)
    case level.to_sym
    when :disabled
      'microphone-slash'
    when :participating
      'volume-up'
    when :watch
      'eye'
    when :mention
      'at'
    when :global
      'globe'
    end
  end

  def notification_icon(level, text = nil)
    icon("#{notification_icon_class(level)} fw", text: text)
  end

  def notification_title(level)
    case level.to_sym
    when :disabled
      '关闭'
    when :participating
      '参与'
    when :watch
      '关注'
    when :mention
      '被提及'
    when :global
      '全局'
    else
      level.to_s.titlecase
    end
  end

  def notification_description(level)
    case level.to_sym
    when :participating
      '您只会收到您参与的活动通知'
    when :mention
      '您将只收到@您的评论的通知'
    when :watch
      '您将收到任何活动的通知'
    when :disabled
      '您将不会通过电子邮件收到任何通知'
    when :global
      '使用您的全局通知设置'
    when :custom
      '您只会收到您自定义的事件的通知'
    end
  end

  def notification_list_item(level, setting)
    title = notification_title(level)

    data = {
      notification_level: level,
      notification_title: title
    }

    content_tag(:li, role: "menuitem") do
      link_to '#', class: "update-notification #{('is-active' if setting.level == level)}", data: data do
        link_output = content_tag(:strong, title, class: 'dropdown-menu-inner-title')
        link_output << content_tag(:span, notification_description(level), class: 'dropdown-menu-inner-content')
      end
    end
  end

  # Identifier to trigger individually dropdowns and custom settings modals in the same view
  def notifications_menu_identifier(type, notification_setting)
    "#{type}-#{notification_setting.user_id}-#{notification_setting.source_id}-#{notification_setting.source_type}"
  end

  # Create hidden field to send notification setting source to controller
  def hidden_setting_source_input(notification_setting)
    return unless notification_setting.source_type
    hidden_field_tag "#{notification_setting.source_type.downcase}_id", notification_setting.source_id
  end

  def notification_event_name(event)
    case event
    when :success_pipeline
      'Successful pipeline'
    else
      event.to_s.humanize
    end
  end
end
