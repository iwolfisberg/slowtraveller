require 'geocoder'
require 'webdrivers'
require 'watir'
require 'yaml'

class PriceService
  def self.calculate_price(steps)
    total_price_min = 0
    total_price_max = 0
    steps.each do |step|
      mode = mode(step)
      prices = scrap_rome2rio(step["departure"], step["arrival"], mode)
      price_min = prices[0]
      price_max = prices[1]
      total_price_min += price_min
      total_price_max += price_max
    end
    return [total_price_min.round(-1), total_price_max.round(-1)]
  end

  # PRIVATE ===================================================================
  private

  def self.scrap_rome2rio(origin, destination, mode)
    mode.downcase!
    url = "https://www.rome2rio.com/map/#{origin}/#{destination}"
    # Creating a browser and going to url
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto(url)
    # Wainting for the price informations to be loaded and get price as string
    browser.element(css: ".js-itinerary-subkind-#{mode}").wait_until(&:present?)
    price = browser.div(css: ".js-itinerary-subkind-#{mode}").span(css: ".route__price")
    # return an array of strings [price_min, price_max]
    price_array = price.text.scan(/\d+/)
    # return an array of integers [price_min, price_max]
    price_array.map! { |price| price.to_i }
    return price_array
  end

  def self.mode(step)
    # tranduit le mode de transport "google" en "rome2rio"
    google_mode = step ["mode"]
    translation = YAML.load_file('db/mode_translation.yml')
    return translation[google_mode].downcase
  end

  # def self.reverse_geocode(lat, long)
  #   results = Geocoder.search([lat, long])
  #   return results.first.city
  # end

  # def self.origin(step)
  #   lat = step["start_location"]["lat"]
  #   long = step["start_location"]["lng"]
  #   reverse_geocode(lat, long)
  # end

  # def self.destination(step)
  #   lat = step["end_location"]["lat"]
  #   long = step["end_location"]["lng"]
  #   reverse_geocode(lat, long)
  # end
end
