class Person < ApplicationRecord
  def save_object
    if create?
      strip_and_downcase_username
      set_default_color_theme
    end

    validate_presence_of(:username, :email, :address)
    validate_uniqueness_of(:username)
    
    if create?
      validate_confirmation_of(:email) 
      validate_acceptance_of(:terms_of_service) 
    end

    if in_moderation_mode?
      validate_presence_of(:profession, :workspace) 
    end
    
    if create?
      geocode 
    end
  
    save
    
    if create? && create_organization?
      create_organization 
    end
  end

  def create_default_organization
    Organization.create(address: address, title: "#{username}'s organization", person: self)
  end

  def in_moderation_mode?
    !!moderation_mode
  end

  def create_organization?
    !!create_an_organization
  end
end
