class ImageUrlValidator < ActiveModel::Validator
  #include HelperMethods

  IMAGE_HOST_WHITELIST = %w(bluemelon.com deviantart.com facebook.com flickr.com freeimagehosting.net imagebam.com imageshack.com imagevenue.com imgur.com instagram postimage.org photobucket.com picasa.com shutterfly.com slickpic.com snapfish.com smugmug.com tinypic.com twitpic.com webshots.com weheartit.com zenfolio.com)

  def validate(record)
    validation_regex = %r{\.(png|jpg|jpeg)$}i
    if validation_regex.match(record.image_url) == nil
      record.errors[:image_url] = 'Invalid format. Image must be png, jpg, or jpeg.'
    end

    if record.image_url.present?
      unless is_whitelisted?(record.image_url) 
        record.errors[:image_url] = 'Invalid image url. Image provider not found in provider whitelist.'
      end
    end
  end

  private


  def is_whitelisted?(url)
    IMAGE_HOST_WHITELIST.any? {|whitelist_item| url.match /#{Regexp.escape(whitelist_item)}/ }
  end
end
