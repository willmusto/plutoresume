PDFKit.configure do |config|
  config.default_options = { page_size: 'A4', 
  	print_media_type: true, 
  	footer_html: Rails.root.join("public", "resume_footer.html").to_s}
  if RUBY_PLATFORM =~ /linux/
    wkhtmltopdf_executable = 'wkhtmltopdf'
  else
    raise "Unsupported. Must be running linux or intel-based Mac OS."
  end
  config.wkhtmltopdf = Rails.root.join('vendor', wkhtmltopdf_executable).to_s
end