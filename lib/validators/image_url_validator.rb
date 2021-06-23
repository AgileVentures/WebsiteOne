# frozen_string_literal: true

class ImageUrlValidator < ActiveModel::Validator
  IMAGE_HOST_WHITELIST = %w(bluemelon.com deviantart.com facebook.com
                            flickr.com freeimagehosting.net imagebam.com imageshack.com
                            imagevenue.com imgur.com instagram postimage.org photobucket.com
                            picasa.com shutterfly.com slickpic.com snapfish.com smugmug.com
                            tinypic.com twitpic.com webshots.com weheartit.com zenfolio.com).freeze

  def validate(record)
    if record.image_url.present?
      if invalid_format?(record.image_url)
        record.errors.add(:image_url, 'Invalid format. Image must be png, jpg, or jpeg.')
      end

      unless is_image_host_whitelisted?(record.image_url)
        record.errors.add(:image_url, 'Invalid image url. Image provider not found in provider whitelist.')
      end
    end
  end

  private

  def invalid_format?(url)
    validation_regex = /\.(png|jpg|jpeg)$/i
    validation_regex.match(url).nil?
  end

  def is_image_host_whitelisted?(url)
    IMAGE_HOST_WHITELIST.any? { |whitelist_item| url.match /#{Regexp.escape(whitelist_item)}/ }
  end
end
