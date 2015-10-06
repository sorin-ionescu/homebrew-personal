class GrowlFramework < Formula
  homepage 'http://growl.info'
  url 'http://growl.cachefly.net/Growl-2.0.1-SDK.zip'
  sha256 'f57c3beeba51738c44f1f741c008815c54352282d1085076e0ed61d6f17806a8'

  def install
    frameworks.install 'Framework/Growl.framework'
  end
end
