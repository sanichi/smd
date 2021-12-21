require 'rails_helper'

describe Contact do
  context "sanitize" do
    it "no effect on names already sanitized and formatted" do
      [
        "Mark John",
        "Sandra Dickie",
        "Seamus O‘Mally",
        "Sean McDonagh",
        "Ian MacNab",
        "Jim & Jean O‘Mally",
        "T. Willy",
      ].each { |name| expect(Contact.sanitize(name)).to eq name }
    end

    it "properly capitalizes" do
      {
        "mark john" => "Mark John",
        "sANDRA"    => "Sandra",
        "o‘mally"   => "O‘Mally",
        "mcDonagh"  => "McDonagh",
        "mcauly"    => "Mcauly",
        "MACNAB"    => "MacNab",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "squishes white space" do
      {
        "\tMark\t \nJohn\r" => "Mark John",
        " O‘Mally    "      => "O‘Mally",
        "\t\r \n"           => "",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "removes invalid characters" do
      {
        "9\"*mark j^o&h!n" => "Mark John",
        "S`a`n`d`r`a`"     => "Sandra",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "treats single-quote like backquote" do
      {
        "O'Mally" => "O‘Mally",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "allows double-barrelled names" do
      {
        "Mary-Kate" => "Mary-Kate",
        "Day-Lewis" => "Day-Lewis",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "inserts full after initials" do
      {
        "A" => "A.",
        "E Howard" => "E. Howard",
        "Edward G" => "Edward G.",
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end

    it "handles blank and nil" do
      {
        ""  => "",
        " " => "",
        nil => ""
      }.each { |before, after| expect(Contact.sanitize(before)).to eq after }
    end
  end
end
