class DisplayInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    attribute_value = object.send(attribute_name)
    attribute_value = attribute_value.strftime('%d/%m/%Y') if attribute_value.instance_of?(Date)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    template.content_tag(:p, attribute_value, merged_input_options)
  end

  def additional_classes
    @additional_classes ||= [input_type].compact
  end
end
