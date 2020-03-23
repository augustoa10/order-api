class CpfValidator < ActiveModel::Validator
  def validate(record)
    attr_name = options[:field] ? options[:field].to_sym : :cpf
    value = record.send(attr_name)
    return true if value.blank? || CPF.valid?(value)
    record.errors.add(attr_name, I18n.t("activerecord.errors.messages.cpf"))
  end
end
