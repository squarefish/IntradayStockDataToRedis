from fugle_marketdata import WebSocketClient, RestClient
import json

# API金鑰記得替換
API_KEY = '***'

client = RestClient(api_key = API_KEY)
stock = client.stock
stock_data = stock.intraday.quote(symbol="2330")
stock_data['isClose'] = 'True'
stock_data['isContinuous'] = 'True'
print(json.dumps(str(stock_data)))
