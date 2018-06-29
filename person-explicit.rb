class Person < ApplicationRecord
  def save_object
    if create?
      strip_and_downcase_username
      set_default_color_theme
    end

    validates_presence_of(:username, :email, :address)
    validates_uniqueness_of(:username)
    
    if create?
      validates_confirmation_of(:email) 
      validates_acceptance_of(terms_of_service) 
    end

    if in_moderation_mode?
      validates_presence_of(:profession, :workspace) 
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
