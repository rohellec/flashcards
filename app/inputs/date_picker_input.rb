class DatePickerInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    date_value = object.send(attribute_name)
    merged_input_options[:value] = date_value.strftime('%d/%m/%Y') if date_value

    template.content_tag(:div, class: "input-group date form_datetime") do
      template.concat @builder.text_field(attribute_name, merged_input_options)
      template.concat div_calendar
    end
  end

  def input_html_options
    super.merge(class: "form-control")
  end

  def div_calendar
    template.content_tag(:div, class: "input-group-addon") do
      template.concat icon_calendar
    end
  end

  def icon_calendar
    "<span class='glyphicon glyphicon-calendar'></span>".html_safe
  end
end
