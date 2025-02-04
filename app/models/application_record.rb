class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  acts_as_paranoid

  def self.model_names
    @model_names ||= begin
      Zeitwerk::Loader.eager_load_all
      ActiveRecord::Base.descendants.map { |m| m.name.underscore }
    end
  end

  def self.valid_csv_attributes
    column_names.map(&:to_sym)
  end

  def self.to_csv(attributes)
    valid_attributes = attributes & valid_csv_attributes
    CSV.generate(headers: true) do |csv|
      csv << valid_attributes

      all.find_each do |model|
        csv << valid_attributes.map { |attr| model.public_send(attr) }
      end
    end
  end
end
