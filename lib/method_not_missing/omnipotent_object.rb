class MethodNotMissing::OmnipotentObject < Array
  include MethodNotMissing

  def inspect
    string = "#<#{self.class.name}:#{self.object_id}"
    instance_variables.each do |var|
      string += " #{var}=#{instance_variable_get(var)}"
    end
    string + ">"
  end
end
