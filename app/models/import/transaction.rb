module Import
  class Transaction
    require 'csv'

    def initialize(file_path, collection)
      @file_path = file_path
      @collection = collection
      @errors = collection.errors
    end

    def import!
      return false unless csv_valid?(@file_path)

      ::Debit::Transaction.transaction do
        transactions_to_save = read_csv(@file_path)
        transactions_to_save.each(&:save!) if @errors[:import_file].empty?
      end
      @errors[:import_file].empty?
    end

    private

    def csv_valid?(file_path)
      csv = CSV.open(file_path, col_sep: ',', headers: true, encoding: 'bom|utf-8')
      headers = csv.read.headers
      unless headers.include?('username')
        @errors.add(:import_file, 'username field must be present')
      end
      headers.include?('username')
    end

    def read_csv(file_path)
      transactions_to_save = []
      CSV.foreach(file_path, headers: true, col_sep: ',', encoding: 'bom|utf-8') do |row|
        transactions_to_save.push(*row_to_transactions(row))
      end
      transactions_to_save
    end

    def row_to_transactions(row)
      row_hash = row.to_hash
      user = ::User.find_by(username: row_hash['username'])
      unless user
        @errors.add(:import_file, "User #{row_hash['username']} not found")
        return
      end
      hash_to_list(row_hash.except('username'), user)
    end

    def hash_to_list(hash, user)
      transactions = []
      hash.each do |description, amount|
        amount = normalize_amount(amount, description, user)
        next if amount.nil? || amount.zero?

        transaction = Debit::Transaction.new(description:, amount:,
                                             collection: @collection, user:)
        (transactions << transaction) && next if transaction.valid?

        @errors.add(:import_file, "Transaction #{description} for user #{user.username} is invalid")
      end
      transactions
    end

    def normalize_amount(amount, description, user)
      return amount if amount.nil?

      begin
        normalized_amount = amount.tr(',', '.')
        raise ArgumentError if Float(normalized_amount).nil? # test whether string is numeric

        normalized_amount.to_d
      rescue ArgumentError
        @errors.add(:import_file,
                    "Transaction #{description} for user #{user.username} has an invalid amount")
        nil
      end
    end
  end
end
