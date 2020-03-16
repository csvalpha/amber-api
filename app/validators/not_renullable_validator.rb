class NotRenullableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    changed = record.changes.dig(attribute)

    return unless changed

    if !changed[0].nil? && changed[1].nil?
      record.errors.add(attribute, 'changed from not-nil to nil')
    end
  end
end
