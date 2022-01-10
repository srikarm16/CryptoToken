from brownie import accounts, NewrlToken
from google_currency import convert
import json, requests

borrower = accounts[1]
lender = accounts[2]

def main():
    t = NewrlToken.deploy({'from': accounts[0]})

    print("Contract Address: ", t)
    print("\n\n")

    while True:
      print(f'Borrower Address: {borrower}')
      print(f'Lender Address: {lender}')
      printBalances(t)

      assetName = input("\nAsset Name: ")
      assetType = input("Gold or Stock: ").lower()
      assetQuantity = int(input("Asset Quantity: "))
      multiplier = 1 if assetType == "stock" else 0.7
      assetValueRupees = multiplier * int(input("Asset Value in Rupees (INR): "))

      assetValueUSD = 10 if assetType == "stock" else float(json.loads(convert('inr', 'usd', assetValueRupees))["amount"])
      assetValue = int(assetValueUSD * assetQuantity * 100)

      print("\n---Registering Asset---")
      t.registerAsset(borrower, assetValue)
      printBalances(t)

      input()
      print("\n---Lender Found---")
      t.lenderFound(borrower, lender, assetValue)
      printBalances(t)

      input()
      print("\n---Deadline End---")
      t.deadlineEnd(borrower, lender, assetValue)
      printBalances(t)

      if input("\nAdd Another Asset (y/n): ").lower() == "n":
        break

      print("\n------------------------------\n")

def printBalances(t):
    print(f'Borrower tokenBalance: {t.balanceOf(borrower)}')
    print(f'Borrower usdBalance: {t.usdBalanceOf(borrower)}')
    print(f'Lender tokenBalance: {t.balanceOf(lender)}')
    print(f'Lender usdBalance: {t.usdBalanceOf(lender)}')
  