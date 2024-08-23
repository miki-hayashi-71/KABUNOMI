module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-[#62CB93]"
    when :alert  then "bg-[#CBB162]"
    when :error  then "bg-[#B03B3B]"
    else "bg-[#C6E4EC]"
    end
  end
end
