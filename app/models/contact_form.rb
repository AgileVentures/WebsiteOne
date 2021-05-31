# frozen_string_literal: true

class ContactForm
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates_presence_of :name, :email, :message
  validates :email, format: { with: Devise.email_regexp }
end
