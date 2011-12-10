require 'rubygems'
require 'awesome_print'
require 'fileutils'
require 'pathname'

include FileUtils

BUNDLES_DIR = "/Users/dleavitt/Library/Application\ Support/TextMate/Bundles_old"
REPO_DIR = "/Users/dleavitt/Desktop/textmate-bundles"

ap Pathname.new(BUNDLES_DIR).entries.map(&:expand_path)
  .find_all { |d| d.directory? }
  .reject { |d| Dir.exists?("#{d}/.git") }

remotes = Pathname.new(BUNDLES_DIR).entries.map(&:expand_path)
  .find_all { |d| d.directory? && Dir.exists?("#{d}/.git") }
  .map do |d| 
    cd d
    `git remote -v`.split("\n").map { |str| 
      str.match(/(\S+)\s+(\S+)\s+\((\w+)\)/)[1..3]
    }
    .find { |m| m[0] == "origin" && m[2] == "fetch" }[1]
  end.map do |repo|
    filename = repo.split("/")[-1]
      .gsub(/\.git$/, '')
      .gsub(/.tmbundle/, '.tmbundle')
      .gsub('-textmate-bundle', '.tmbundle')
    
    [filename =~ /.tmbundle$/ ? filename : "#{filename}.tmbundle", repo]
  end
# TODO: convert names to .tmbundle
cd REPO_DIR do
  remotes.each do |remote|
    # ap `git submodule add #{remote[1]} #{remote[0]}`
  end
end
