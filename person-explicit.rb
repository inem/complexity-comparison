class Person < ApplicationRecord
  def save_object
    validates_presence_of(:username, :email, :address)
    validates_confirmation_of(:email) if create?
    validates_acceptance_of(terms_of_service) if create?
    validates_presence_of(:profession, :workspace) if in_moderation_mode?
    geocode if create?
    save
    create_organization if create? && create_organization?
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
