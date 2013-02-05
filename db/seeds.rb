require 'csv'

CSV.foreach("#{Rails.root}/tmp/data.csv", headers: true) do |row|
  account = Account.find_by_name(row['Account']) || Account.create(name: row['Account']) 
  envelope = Envelope.find_by_name(row['Envelope']) || Envelope.create(name: row['Envelope'])
  Transaction.create payee: row['Payee'], amount: row['Amount'], account: account, envelope: envelope, entry_date: row['Date']
end

Account.all.each { |a| a.update_attribute(:balance, 0) }
Envelope.all.each { |e| e.update_attribute(:balance, 0) }

account_balances = [
  { name: 'US Bank Credit Card', balance: -1048.31 }, 
  { name: 'US Bank Checking', balance: 5995.87 }, 
  { name: 'ING Savings', balance: 11251.20 }
]

envelope_balances = [
  { name: 'Mortgage/Rent', balance: 2701.60 }, 
  { name: 'Medical/Dental', balance: 90.88 }, 
  { name: 'Groceries', balance: 513.71 }, 
  { name: 'Dining', balance: 127.65 }, 
  { name: 'Automobile', balance: 219.52 }, 
  { name: 'Auto Fuel', balance: 75 }, 
  { name: 'Utilities', balance: 371.77 }, 
  { name: 'Wireless Phone', balance: 138.50 }, 
  { name: 'Auto Insurance', balance: 351.36 }, 
  { name: 'Cable/Internet', balance: 69.24 }, 
  { name: 'Home Repair/Maintenance', balance: 40 }, 
  { name: 'Pet Care', balance: 126.75 }, 
  { name: 'Entertainment', balance: 17.81 }, 
  { name: 'Savings', balance: 180.45 }, 
]

account_balances.each do |a|
  Account.find_by_name(a['name']).update_attribute(:balance, a['balance'])
end

envelope_balances.each do |e|
  Envelope.find_by_name(e['name']).update_attribute(:balance, e['balance'])
end

# envelopes = Envelope.create([
#   { name: 'mortgage' }, 
#   { name: 'dining' }, 
#   { name: 'groceries' }, 
#   { name: 'auto' }, 
#   { name: 'savings' }, 
#   { name: 'medical' }, 
#   { name: 'utilities' }, 
#   { name: 'internet access' }, 
#   { name: 'cell phone' }, 
#   { name: 'home maintenance' }, 
#   { name: 'entertainment' }, 
#   { name: 'pet care' }, 
#   { name: 'gifts' }, 
#   { name: 'salary' }
# ])

# accounts = Account.create([
#   { name: 'checking', balance: 3427.26 }, 
#   { name: 'savings', balance: 11251.20 }, 
#   { name: 'credit card', balance: -2224.03 }
# ])

# transactions = Transaction.create([
#   { payee: 'Kroger', amount: -35.24, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('groceries') }, 
#   { payee: 'Shell', amount: -27.83, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('auto') }, 
#   { payee: 'Duke Energy', amount: -54.35, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('utilities') }, 
#   { payee: 'US Bank', amount: -100, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('mortgage') }, 
#   { payee: 'A Tavola', amount: -65, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('dining') }, 
#   { payee: 'Meijer', amount: -46.35, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('groceries') }, 
#   { payee: 'Walgreens', amount: -10, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('medical') }, 
# ])