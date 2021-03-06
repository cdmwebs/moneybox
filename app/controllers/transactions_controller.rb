class TransactionsController < ApplicationController

  before_filter :check_polarity, only: [:update, :create]

  def new
    @transaction = Transaction.new
  end

  def edit
    @transaction = Transaction.find params[:id]
  end


  def update
    @transaction = Transaction.find params[:id]
    @transaction.update_attributes params[:transaction]
    if @transaction.valid?
      flash[:success] = "&ldquo;#{@transaction.payee}&rdquo; transaction updated"
      redirect_to transactions_path
    else
      flash[:error] = "Please see errors, below"
      render 'edit'
    end
  end

  def toggle_status
    transaction = Transaction.find params[:id]
    transaction.toggle_status
    transaction.save
    redirect_to :back
  end

  def create
    @transaction = Transaction.create params[:transaction]
    if @transaction.valid?
      flash[:success] = "&ldquo;#{@transaction.payee}&rdquo; transaction created"
      redirect_to transactions_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
  end

  def destroy
    if Transaction.find(params[:id]).destroy
      flash[:success] = "Transaction deleted"
    else
      flash[:error] = "Could not delete transaction"
    end
    render 'index'
  end

  def import
    require 'csv'
    if request.post?
      upload = params[:transaction][:attachment]
      if upload.content_type == 'text/csv'
        if params[:replace].present?
          Transaction.delete_all
          Account.delete_all
          Envelope.delete_all
        end
        ctr = 0
        errors = []
        CSV.foreach( upload.tempfile, headers: true ) do |row|
          account = Account.find_or_create_by_name(row['account'])
          envelope = Envelope.find_or_create_by_name(row['envelope'])
          new_transaction = Transaction.create payee: row['payee'], amount: row['amount'], account: account, envelope: envelope, entry_date: row['date'], memo: row['memo']
          errors << "#{row['date']} - #{row['payee']} - #{row['amount']} (#{new_transaction.errors.messages.inspect})" if ! new_transaction.valid?
          ctr += 1
        end
        Account.all.each{ |a| a.update_attribute( :balance, 0) } if params['reset-accounts'].present?
        Envelope.all.each{ |e| e.update_attribute( :balance, 0) } if params['reset-envelopes'].present?
        flash[:success] = "#{ctr} transactions created, #{Envelope.count} envelopes created and #{Account.count} accounts created"
        flash[:error] = "<p>There were errors, though:</p><ul><li>#{errors.join('</li><li>')}</li></ul><p>You may want to fix your data and try importing again.</p>" if errors.size > 0
      else
        flash[:error] = "Incorrect file type"
      end
    end
    render 'import'
  end

  def export
    require 'csv'
    output = Tempfile.new ['export.', '.csv']
    CSV.open(output.path, "wb") do |csv|
      csv << ['entry date', 'payee', 'memo', 'envelope', 'account', 'amount']
      Transaction.all.each do |t|
        envelope = t.envelope.present? ? t.envelope.name : nil
        account = t.account.present? ? t.account.name : nil
        csv << [t.entry_date, t.payee, t.memo, envelope, account, t.amount.to_s]
      end
    end
    send_file output.path
  end

  private

    def check_polarity
      amount = params[:transaction][:amount].to_f 
      params[:transaction][:amount] = params[:withdrawal] == 'y' ? 0 - amount.abs : amount.abs
    end

end
