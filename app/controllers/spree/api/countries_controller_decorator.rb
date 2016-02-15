Spree::Api::CountriesController.class_eval do
	def allCountries
		@countries = Spree::Country.all
		respond_with(@countries, :status => 200,:default_template => :allCountries)
	end
end
