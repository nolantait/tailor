
RSpec.describe Tailor::Style do
  describe "#add" do
    it "adds the styles together" do
      style = described_class.new(classes: ["p-sm"])
      other_style = described_class.new(classes: ["block"])
      classes = style.add(other_style).classes

      expect(classes).to contain_exactly("p-sm", "block")
    end
  end

  describe "#remove" do
    it "removes the styles" do
      style = described_class.new(classes: ["p-sm", "block"])
      other_style = described_class.new(classes: ["block"])
      classes = style.remove(other_style).classes

      expect(classes).to contain_exactly("p-sm")
    end
  end

  describe "#merge" do
    it "merges the styles" do
      style = described_class.new(classes: ["p-sm", "block"])
      other_style = described_class.new(classes: ["block", "bg-red-500"])
      classes = style.merge(other_style).classes

      expect(classes).to contain_exactly("p-sm", "block", "bg-red-500")
    end
  end
end
