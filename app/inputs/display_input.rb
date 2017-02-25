class DisplayInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    attribute_value = object.send(attribute_name)
    if attribute_value.instance_of?(Date)
      attribute_value.strftime('%d/%m/%Y')
    else
      attribute_value
    end
  end

  def additional_classes
    @additional_classes ||= [input_type].compact
  end
end
