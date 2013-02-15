module EnvelopesHelper

  def options_with_balance(src)
    output_html = ''
    src.each do |envelope|
      output_html << "<option value=\"#{envelope.id}\" data-balance=\"#{envelope.balance}\">#{envelope.name_and_balance}</option>"
    end
    output_html
  end

end
