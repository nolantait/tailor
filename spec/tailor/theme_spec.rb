RSpec.describe Tailor::Theme do
  describe "initialization" do
    it "inits with no args" do
      theme = described_class.new
      expect(theme[:container].to_s).to eq ""
    end

    it "inits with a hash of initial keys" do
      theme = described_class.new(container: ["justify-between"])
      expect(theme[:container].to_s).to eq "justify-between"
    end
  end

  describe "#add" do
    it "adds a style" do
      theme = described_class.new
      theme.add(:container, "justify-between")

      expect(theme[:container].to_s).to eq "justify-between"
    end

    it "adds a singleton method" do
      theme = described_class.new
      theme.add(:container, "justify-between")

      other_theme = theme.dup
      other_theme.add(:container, "p-sm")

      expect(theme.container.to_s).to eq "justify-between"
      expect(other_theme.container.to_s).to eq "justify-between p-sm"
    end
  end

  describe "#remove" do
    it "removes a style" do
      theme = described_class.new(container: ["justify-between"])
      theme.remove(:container, "justify-between")

      expect(theme[:container].to_s).to eq ""
    end
  end

  describe "#inherit" do
    it "inherits from another theme, keeping any keys it already has" do
      theme = described_class.new(container: ["justify-between"])
      other_theme = described_class.new(container: ["p-sm"], button: ["btn"])

      inherited = theme.inherit(other_theme)

      expect(inherited[:container].to_s).to eq "justify-between"
      expect(inherited[:button].to_s).to eq "btn"
    end
  end

  describe "#override" do
    it "overrides using another theme, replacing any keys it finds" do
      theme = described_class.new(container: ["justify-between"])
      other_theme = described_class.new(container: ["p-sm"], button: ["btn"])

      overridden = theme.override(other_theme)

      expect(overridden[:container].to_s).to eq "p-sm"
      expect(overridden[:button].to_s).to eq "btn"
    end
  end

  describe "#merge" do
    it "merges with another theme, merging values for keys and adding any new ones" do
      theme = described_class.new(container: ["justify-between"])
      other_theme = described_class.new(container: ["p-sm"], button: ["btn"])

      merged = theme.merge(other_theme)

      expect(merged[:container].to_s).to eq "justify-between p-sm"
      expect(merged[:button].to_s).to eq "btn"
    end
  end
end
