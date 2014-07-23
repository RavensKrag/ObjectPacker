ARGS name style_name_list

BODY {

cascade = ThoughtTrace::Style::Cascade.new name

cascade.style_list = style_name_list

}

OBJECT cascade