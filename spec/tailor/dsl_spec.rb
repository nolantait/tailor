class MyStyle
  include Tailor::DSL

  style :container, ["justify-between"]
end

RSpec.describe Tailor::DSL do
  it "has a dsl" do
    klass = MyStyle.new
    expect(klass.style[:container].to_s).to eq "justify-between"

    klass.style[:container].add("p-sm")
    expect(klass.style[:container].to_s).to eq "justify-between p-sm"
  end
end
