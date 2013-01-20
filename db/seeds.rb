envelopes = Envelope.create([
  { name: 'mortgage' }, 
  { name: 'dining' }, 
  { name: 'groceries' }, 
  { name: 'auto' }, 
  { name: 'savings' }, 
  { name: 'medical' }, 
  { name: 'utilities' }, 
  { name: 'internet access' }, 
  { name: 'cell phone' }, 
  { name: 'home maintenance' }, 
  { name: 'entertainment' }, 
  { name: 'pet care' }, 
  { name: 'gifts' }, 
  { name: 'salary' }
])

accounts = Account.create([
  { name: 'checking', balance: 3427.26 }, 
  { name: 'savings', balance: 11251.20 }, 
  { name: 'credit card', balance: -2224.03 }
])

transactions = Transaction.create([
  { payee: 'Kroger', amount: -35.24, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('groceries') }, 
  { payee: 'Shell', amount: -27.83, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('auto') }, 
  { payee: 'Duke Energy', amount: -54.35, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('utilities') }, 
  { payee: 'US Bank', amount: -100, account: Account.find_by_name('checking'), envelope: Envelope.find_by_name('mortgage') }, 
  { payee: 'A Tavola', amount: -65, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('dining') }, 
  { payee: 'Meijer', amount: -46.35, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('groceries') }, 
  { payee: 'Walgreens', amount: -10, account: Account.find_by_name('credit card'), envelope: Envelope.find_by_name('medical') }, 
])