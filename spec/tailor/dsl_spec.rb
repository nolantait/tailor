class MyStyle
  include Tailor::DSL

  style :container, %w[justify-between]
  style :empty, %w[]

  tailor :header do
    style :title, %w[text-2xl]
  end
end

RSpec.describe Tailor::DSL do
  it "has a dsl" do
    klass = MyStyle.new
    expect(klass.style[:container].to_s).to eq "justify-between"

    klass.style[:container].add("p-sm")
    expect(klass.style[:container].to_s).to eq "justify-between p-sm"

    expect(klass.style[:header][:title].to_s).to eq "text-2xl"
    expect(klass.style.header.title.to_s).to eq "text-2xl"

    expect(klass.style.empty.to_s).to eq ""
  end
end
