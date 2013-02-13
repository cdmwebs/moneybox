unless Rails.env.production?
  ENV['SENDGRID_USERNAME'] = 'WarrenHarrison'
  ENV['SENDGRID_PASSWORD'] = '5!3Sstw!afs7A4'
  ENV['SENDGRID_DOMAIN'] = 'moneybox.dev'
  ENV['AWS_ACCESS_KEY_ID'] = 'AKIAJ54NTHCZ3C7R2NSQ'
  ENV['AWS_SECRET_ACCESS_KEY'] = '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'
  ENV['S3_BUCKET_NAME'] = 'hm-moneybox'
end