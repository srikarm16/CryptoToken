from google_currency import convert
import json, requests

# conversionRate = convert('usd', 'inr', 1)
# amount = json.loads(conversionRate)["amount"]

# print(conversionRate)
# print(amount)

assetName = input("Asset Name: ")
assetType = input("Gold or Stock: ").lower()
assetQuantity = int(input("Asset Quantity: "))
multiplier = 1 if assetType == "stock" else 0.7
assetValueRupees = multiplier * int(input("Asset Value in Rupees (INR): "))

url = 'https://api.newrl.net/create-token'
createTokenBody = {
    "token_name": assetName,
    "token_type": assetType,
    "first_owner": "0x1234",
    "custodian": "0x1234",
    "legal_doc": "7890",
    "amount_created": str(assetQuantity),
    "value_created": str(assetValueRupees)
}

responseFile = requests.post(url, data=createTokenBody, allow_redirects=True, headers={
    "Content-Type": "application/json",
    'accept': 'application/json'
})
print("RESPONSE", responseFile.text)

with open(responseFile) as f:
  data = json.load(f)
  print("DATA", data)