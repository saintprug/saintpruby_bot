class GiphyClient
  API_URL = "https://api.giphy.com/v1/gifs/random?rating=G&tag=chug&api_key=#{ENV.fetch('GIPHY_API_TOKEN')}".freeze

  def send_request
    response = Faraday.get(API_URL)

    JSON.parse(response.body, symbolize_names: true)
  end
end
