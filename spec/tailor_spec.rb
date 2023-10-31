# frozen_string_literal: true

RSpec.describe Tailor do
  it "has a version number" do
    expect(described_class::VERSION).not_to be_nil
  end

  it "does something useful" do
    style = described_class.new
    style.add(:container, "justify-between")
    style.add(:container, "p-sm")
    style.add(:container, "flex")
    style.remove(:container, "justify-between")

    expect(style[:container].to_s).to eq("p-sm flex")

    other_style = described_class.new
    other_style.add(:container, "p-lg")
    other_style.add(:button, "btn")

    inherited_style = style.inherit(other_style)

    expect(inherited_style[:container].to_s).to eq("p-sm flex")
    expect(inherited_style[:button].to_s).to eq("btn")

    merged_style = style.merge(other_style)

    expect(merged_style[:container].to_s).to eq("p-lg")
    expect(merged_style[:button].to_s).to eq("btn")
  end

  class MyStyle
    include Tailor::DSL

    style :container, ["justify-between"]
  end

  it "has a dsl" do
    klass = MyStyle.new
    expect(klass.style[:container].to_s).to eq "justify-between"

    klass.style[:container].add("p-sm")
    expect(klass.style[:container].to_s).to eq "justify-between p-sm"
  end
end
