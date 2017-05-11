class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    date_value = object.send(attribute_name)
    merged_input_options[:value] = date_value.strftime('%d/%m/%Y') if date_value

    @builder.text_field(attribute_name, merged_input_options)
  end

  # override label_html_options method to generate label 'for' attribute correctly
  def label_html_options
    super.merge(for: "#{object_name}_#{attribute_name}")
  end
end
