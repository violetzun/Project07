Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1430853597140936', '634adbc1d45ea79231d903cd50f43586'

end