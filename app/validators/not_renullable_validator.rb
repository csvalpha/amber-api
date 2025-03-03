class NotRenullableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    changed = record.changes[attribute]

    return unless changed

    record.errors.add(attribute, 'changed from not-nil to nil') if !changed[0].nil? && changed[1].nil?
  end
end
