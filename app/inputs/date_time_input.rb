class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    date_value = object.send(attribute_name)
    merged_input_options[:value] = date_value.strftime('%d/%m/%Y') if date_value

    @builder.text_field(attribute_name, merged_input_options)
  end
end
