require "jet_black"

RSpec.describe JetBlack::Session, "#append_to_file" do
  it "appends the contents provided" do
    subject.run("echo 'original' > file.txt")

    subject.append_to_file "file.txt", <<~TXT
      ooh
      new
      lines
    TXT

    command = subject.run("cat file.txt")
    expected_content = <<~TXT
      original
      ooh
      new
      lines
    TXT

    expect(command.stdout).to eq expected_content.chomp
  end

  it "raises an error if the target file doesn't exist" do
    append_to_file = Proc.new do
      subject.append_to_file("nope.txt", "doh")
    end

    expect(append_to_file).to raise_error(JetBlack::NonExistentFileError) do |e|
      expect(e.raw_path).to eq "nope.txt"
      expect(e.expanded_path).to_not be_empty
    end
  end
end
