class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :is_field_empty, :num_of_forms, :bullet_point_items, :get_header, :is_company_same_as_last_one, :asset_data_base64, :get_sub_header, 
                :is_param_array_empty, :get_rest_of_title, :get_first_letter

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # Checks if input field is empty. If it is, then we won't show it
  # in the template
  def is_field_empty(param=nil)
    if param.kind_of?(Array)
      if param[0].blank?
        return true
      else
        return false
      end
    elsif param.blank?
      return true
    elsif param.nil?
      return false
    end
  	# if params[param].nil?
  	# 	return false
  	# end
  	# if params[param].empty?
   #    return true
   #  else
   #    return false
   #  end
  end

  # Checks if params array is empty like ["", ""]
  # if it is, we'll skip it.
  def is_param_array_empty(array)
    return array.reject {|i| i.empty? }.empty?
  end
  

  # Gets the number of dynamic forms that are submitted
  def num_of_forms(param)
    if params[param][0].empty?
      return 0
    elsif params[param].nil?
      return 0
    end
    # Removes "" (blank entries) from array.
    # In case user clicks on + but doesn't fill anything in.
    return params[param].reject {|i| i.empty? }.length
  end

  # Splits each item after enter is pressed.
  # This is for specific text boxes.
  # We use this for making bullet points on resume.
  def bullet_point_items(item_arr)
    items = item_arr.split("\n")
    items
  end

  # Gets candidate's full name, featured degree(s), certifications, etc.
  def get_header

    featured_degrees = ''
    featured_certs_licenses = ''

    if get_featured_abbreviations('degree_abbreviations')
      featured_degrees = get_featured_abbreviations('degree_abbreviations').join(", ")
    end
    if get_featured_abbreviations('cert_or_license_abbreviations')
      featured_certs_licenses = get_featured_abbreviations('cert_or_license_abbreviations').join(", ")
    end
    
    if featured_degrees.empty? && featured_certs_licenses.empty?
      header = "#{params[:full_name]}"
    elsif featured_degrees.empty?
      header = "#{params[:full_name] + ', ' + featured_certs_licenses}"
    elsif featured_certs_licenses.empty?
      header = "#{params[:full_name] + ', ' + featured_degrees}"
    else
      header = "#{params[:full_name] + ', ' + featured_degrees + ', ' +  featured_certs_licenses}"
    end

    header_to_json(header)

    header
  end

  # writes header to JSON file so we can get a dynamic header
  def header_to_json(header)
    File.write("#{Rails.root}/public/header.json", "var data = '{" + '"header"' + ':' + '"' + "#{header}" + '"'+ "}'");
  end

  # Gets candidate's street address, city, ST Zip, Phone, and email
  def get_sub_header
    street = params[:primary_address_1]
    city = params[:city]
    state = get_state_abbreviation(params[:state])
    zip = params[:zip_code]
    phone = "#{params[:phone_number_1] + '.' + params[:phone_number_2] + '.' + params[:phone_number_3]}"
    email = params[:email]

    if email.blank? && params[:phone_number_1].blank?
      sub_header = "#{street + ' &bull; ' + city + ', ' + state + ' ' + zip}"
    elsif email.blank?
      sub_header = "#{street + ' &bull; ' + city + ', ' + state + ' ' + zip + ' &bull; ' + email}"
    elsif state.blank?
      sub_header = "#{street + ' &bull; ' + city + ', ' + zip + ' &bull; ' + phone + ' &bull; ' + email}"
    else
      sub_header = "#{street + ' &bull; ' + city + ', ' + state + ' ' + zip + ' &bull; ' + phone + ' &bull; ' + email}"
    end
  end

  # Checks if candidate has multiple entries of the same company
  # if he has, then we'll use slightly different HTML output
  def is_company_same_as_last_one(current_company, current_index)
    
    all_companies = params[:company_names]
    company = current_company
    
    # current index is not current index. It's current index + 1.
    # to access previous element for matching we subtract 2 from it.
    if current_index - 1 != 0 && company == params[:company_names][current_index - 2]
      true
    else
      false
    end
  end

  def is_next_company_same(company, index)
    counter = 0
    company_places_in_array = []

    company_names.each_with_index do |c, i|
      if ((company == c) && ((index - i).abs == 1))
        counter += 1
      else
        counter = 0
      end
    end

    return counter
  end


  end

  # checks if next company is the same. If it is, then we'll display
  # the start of the first job in that company and we'll join that
  # with end/current date for that job
  def is_next_company_same(current_company, current_index, company_params)
    start_month = params[:start_months][current_index]
    start_year = params[:start_years][current_index]
    start_time = []
    changed = false

    if company_params.length - 1 > current_index
      
      company_params.each_with_index do |company, index|
        if company_params.length > 1
          if current_company == company && current_company == company_params[current_index + 1]
            start_month = params[:start_months][index]
            start_year = params[:start_years][index]
            changed = true      
          elsif index != 0
            if (current_company == company) && ((current_index - index).abs == 1)
              start_month = params[:start_months][index]
              start_year = params[:start_years][index]
              changed = true
            end     
          else
            changed = false
          end
        else
          return false
        end
      end
    end

    if changed == true
      start_time.push(start_month, start_year)
    else
      return false
    end 
  end

  # checks if company is unique, but only if it is unique to its nearest
  # left/right elements e.g [a,b,b,a] is true for b
  def is_company_unique(current_company, company_params)
    times = 0
    company_params.each_with_index do |company, i|
      if i == 0
        if company == current_company && company_params[i + 1] == company
          times += 1
        end
      elsif i == company_params.length - 1
        if company == current_company && company_params[i - 1] == company
          times += 1
        end
      else
        if company == current_company && company_params[i + 1] == company
          times += 1
        end
      end        
      # if company == company_params[i - 1] || company_params[i + 1]
      #   times += 1
      # end
    end

    if times == 1
      false
    elsif times == 0
      true
    else
      false
    end
  end

  # Gets start month, start year - end month, end year
  def get_date(start_month, start_year, end_month, end_year, current_index)

    if current_index - 1 == 0 && (end_month[0].blank? || end_year[0].blank?)
      if start_month.blank?
        date = "#{start_year + ' - ' + 'Present'}"
      else
        date = "#{start_month + ' ' + start_year + ' - ' + 'Present'}"
      end
    else
      if start_month.blank?
        date = "#{start_year + ' - ' + end_year}"
      else
        date = "#{start_month + ' ' + start_year + ' - ' + end_month + ' ' + end_year}"
      end
    end
    date
  end

  # Gets state abbreviation from full state name (e.g "Wyoming" to "WY")
  def get_state_abbreviation(param_state)
    states = File.read("#{Rails.root}/public/states.json")
    states = ActiveSupport::JSON.decode(states)
    
    states["states"].key(param_state)
  end

  # Checks if item is checked as 'Featured'
  def is_featured(abbreviation_array, item)
    if !abbreviation_array.nil?
      abbreviation_array.include?(item)
    end
  end

  # Gets candidate's degree name, school name, city, and state
  def get_education_section(degree_name, school_name, city, state)
    state_abbreviation = get_state_abbreviation(state)
    education_info = "#{degree_name + ', ' + school_name + ' - ' + city + ', ' + state_abbreviation}"
  end

  # Returns certification abbreviation and cert/license name
  def get_cert_and_license_section(cert_or_license_abbreviations, cert_or_license)
    return "#{cert_or_license_abbreviations + ', ' + cert_or_license}"
  end

  # Returns membership abbreviation, organization full name and position held within organization
  def get_mship_affiliations_section(membership_abbreviation, organization_name, position)
    return "#{membership_abbreviation + ', ' + organization_name + ' - ' + position}"
  end

  # gets Other and Other 2 title after the first letter
  def get_rest_of_title(title)
    return title[1..-1]
  end

  # gets first letter from title
  def get_first_letter(title)
    return title[0]
  end

  private

    # Gets all the featured degrees/certifications/licenses that are marked with Featured checkmark
    def get_featured_abbreviations(featured_param)
      featured_abbreviations = []

      # If there are no check marks, just return false,
      # otherwise, for each checkmark, add to featured_abbreviations array
      # corresponding abbreviation
      if params[featured_param + '_featured'].blank?
        return false
      else
        (1..params["#{featured_param + '_featured'}"].length).each do |i|
          featured_abbreviations.push(params[featured_param + '_featured'][i - 1])
        end
      end
      featured_abbreviations
    end
end
