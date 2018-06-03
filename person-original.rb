class Person < ApplicationRecord
  attr_accessor :create_an_organization
  attr_accessor :moderation_mode

  belongs_to :organization

  validates_presence_of :username, :email, :address
  validates_confirmation_of :email, on: :create
  validates_acceptance_of :terms_of_service, on: :create
  validates_presence_of :profession, :workplace if: :in_moderation_mode?

  geocoded_by :address
  before_save :geocode, on: :create

  before_validation :strip_and_downcase_username, on: :create
  before_validation :set_default_color_theme, on: :create

  after_save :create_default_organization if: :create_organization?

  def create_default_organization
    Organization.create(address: address, title: "#{username}'s organization", person: self)
  end

  def in_moderation_mode?
    !!moderation_mode
  end

  def create_organization?
    !!create_an_organization
  end

  def strip_and_downcase_username; end
  def set_default_color_theme; end
end