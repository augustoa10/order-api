# Checks if the value of an attribute is a valid IMEI number.
class ImeiValidator < ActiveModel::Validator

  # 356843052637512 or 35-6843052-637512 or 35.6843052.637512
  IMEI_FORMAT = /\A[\d\.\:\-\s]+\z/i

  def validate(record)
    attr_name = options[:field] ? options[:field].to_sym : :device_imei
    value = record.send(attr_name)
    return true if value.blank? || (validate_format(value) && validate_luhn_checksum(value.gsub(/\D/, '').reverse))
    record.errors.add(attr_name, I18n.t("activerecord.errors.messages.device_imei"))
  end

  def validate_format(imei_number)
    (imei_number =~ IMEI_FORMAT).present?
  end

  def validate_luhn_checksum(numbers)
    sum = 0
    i = 0

    numbers.each_char do |ch|
      n = ch.to_i
      n *= 2 if i.odd?
      n = 1 + (n - 10) if n >= 10

      sum += n
      i += 1
    end

    (sum % 10).zero?
  end
end
