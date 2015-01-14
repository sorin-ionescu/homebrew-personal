class GrowlFramework < Formula
  homepage 'http://growl.info'
  url 'http://growl.cachefly.net/Growl-2.0.1-SDK.zip'
  sha1 'c69b3026661aec6a8455ba9b6e90452e0c1e89aa'

  def install
    frameworks.install 'Framework/Growl.framework'
  end
end
