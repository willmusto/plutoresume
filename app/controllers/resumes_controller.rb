require 'google/apis/script_v1'
require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'
require 'htmltoword'
require 'nokogiri'

class ResumesController < ApplicationController

	def new
		# Read list of states so they can be loaded into drop-down menu
		# on resume
		@data = File.read("#{Rails.root}/public/states.json")
		@data = ActiveSupport::JSON.decode(@data)

		@data_months = File.read("#{Rails.root}/public/months.json")
		@data_months = ActiveSupport::JSON.decode(@data_months)

		# Extract only state names
		@states = []
		@data['states'].each do |state|
			@states.push(state[1])
		end

		# Extract month names
		@months = []
		@data_months['months'].each do |month|
			@months.push(month[1])
		end
	end

	# Uploads authenticated user's resume to GDrive's master shared folder
	def create
		# fail
		unless session.has_key?(:credentials)
			return redirect_to('/auth/google_oauth2/callback')
		end
		client_opts = JSON.parse(session[:credentials])
		auth_client = Signet::OAuth2::Client.new(client_opts)
		drive = Google::Apis::DriveV2::DriveService.new

		drive.authorization = auth_client
		
		# Inside parents: [{"id": '0B4kn-7aQywsRYmhXZV8zZ2REU0E'}]} replace the id '0B4kn-7aQywsRYmhXZV8zZ2REU0E' with the id of your master shared folder
		# in which you want PDF file to get uploaded
		resume = template_to_pdf
		filename = "#{get_header}"
		drive.insert_file({title: filename + '.pdf', parents: [{"id": '0B6xmCwBlc1DoQWhTNDg2a1p1UWs'}]}, upload_source: resume,
			content_type: 'application/pdf')

		# Inside parents: [{"id": '0B4kn-7aQywsRYmhXZV8zZ2REU0E'}]} replace the id '0B4kn-7aQywsRYmhXZV8zZ2REU0E' with the id of your master shared folder
		# in which you want Word file to get uploaded
		drive.insert_file({title: filename + '.docx', parents: [{"id": '0B6xmCwBlc1DoWTBibXNfbmZQbDQ'}]}, upload_source: resume,
			content_type: 'application/msword')

		File.delete(resume) if File.exist?(resume)

		# template_to_pdf
	end

	private

		# This will convert HTML + CSS into a .pdf file
		def template_to_pdf
			content = File.read("#{Rails.root}/public/resume_copy.html.erb")
			# content = File.read("#{Rails.root}/app/views/resumes/_sample_resume_unminified_work.html.erb")
			template = ERB.new(content)
			kit = PDFKit.new(template.result(binding), :header_html => "#{Rails.root}/public/resume_header.html")
			# File.open("#{Rails.root}/public/template_result.pdf", 'w')
			# kit.stylesheets << "#{Rails.root}/public/my_css.css"
			
			
			filename = "#{Rails.root}/public/" + "#{(0...10).map { (65 + rand(26)).chr }.join}" + ".pdf"
			file = kit.to_file(filename)

			return filename

			# file = kit.to_file("#{Rails.root}/public/template_result.pdf")
			# send_data kit.to_pdf, :filename => "whatever.pdf",
	  #     :type => "application/pdf",
	  #     :disposition  => "inline" # either "inline" or "attachment"
		end
end
