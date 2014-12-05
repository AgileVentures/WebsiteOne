class ImageUrlValidator < ActiveModel::Validator

  IMAGE_HOST_WHITELIST = %w(bluemelon.com deviantart.com facebook.com flickr.com freeimagehosting.net imagebam.com imageshack.com imagevenue.com imgur.com instagram postimage.org photobucket.com picasa.com shutterfly.com slickpic.com snapfish.com smugmug.com tinypic.com twitpic.com webshots.com weheartit.com zenfolio.com)

  def validate(record)
    is_whitelisted?(record.image_url) if record.image_url.present?
  end

  private

  def is_whitelisted?(url)
    IMAGE_HOST_WHITELIST.include? url
  end
end
