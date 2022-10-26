module Import
  class Transaction
    include SpreadsheetHelper

    def initialize(file, collection)
      @file = file
      @collection = collection
      @errors = collection.errors
    end

    def import!
      return false unless valid?(@file)

      ::Debit::Transaction.transaction do
        transactions_to_save = read_spreadsheet(@file)
        transactions_to_save.each(&:save!) if @errors[:import_file].empty?
      end
      @errors[:import_file].empty?
    end

    private

    def valid?(file)
      headers = get_headers(file)
      unless headers.include?('username')
        @errors.add(:import_file, 'username field must be present')
      end
      headers.include?('username')
    end

    def read_spreadsheet(file)
      transactions_to_save = []

      get_rows(file).map do |row|
        transactions_to_save.push(*row_to_transactions(row))
      end
      transactions_to_save
    end

    def row_to_transactions(row)
      user = ::User.find_by(username: row['username'])
      unless user
        @errors.add(:import_file, "User #{row['username']} not found")
        return
      end
      hash_to_list(row.except('username'), user)
    end

    def hash_to_list(hash, user)
      transactions = []
      hash.each do |description, amount|
        amount = normalize_amount(amount, description, user)
        next if amount.nil? || amount.zero?

        transaction = Debit::Transaction.new(description: description, amount: amount,
                                             collection: @collection, user: user)
        (transactions << transaction) && next if transaction.valid?

        @errors.add(:import_file, "Transaction #{description} for user #{user.username} is invalid")
      end
      transactions
    end

    def normalize_amount(amount, description, user)
      return amount if amount.nil?

      begin
        amount = amount.tr(',', '.') if amount.instance_of?(String)
        raise ArgumentError if Float(amount).nil? # test whether string is numeric

        amount.to_d
      rescue ArgumentError
        @errors.add(:import_file,
                    "Transaction #{description} for user #{user.username} has an invalid amount")
        nil
      end
    end
  end
end
