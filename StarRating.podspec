Pod::Spec.new do |s|
  s.name         = "StarRating"
  s.version      = "0.0.1"
  s.summary      = "An interactive star rating control for iOS applications."
  s.homepage     = "https://github.com/martega/star-rating"
  s.author       = { "Martin Ortega" => "martega6@gmail.com" }
  s.source       = { :git => "https://github.com/martega/star-rating.git", :tag => s.version.to_s }
  s.source_files  = 'StarRating', 'StarRating/**/*.{h,m}'
  s.resources = "StarRating/*.png"
  s.requires_arc = true
end
