# frozen_string_literal: true

class ContactForm
  include ActiveModel::Model

  attr_accessor :name, :email, :message

  validates :name, :email, :message, presence: true
  validates :email, format: { with: Devise.email_regexp }
end
