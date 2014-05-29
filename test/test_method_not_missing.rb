require 'method_not_missing'
require 'minitest/autorun'

describe "MethodNotMissing" do
  let(:object) { MethodNotMissing::OmnipotentObject.new }
  it "works" do
    object.methods.wont_include :update
    object.update([3]).must_equal [3]
    object.methods.must_include :update
    object.update([4]).must_equal [3, 4]
  end
end
