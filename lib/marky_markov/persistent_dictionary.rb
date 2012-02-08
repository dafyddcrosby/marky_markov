require 'yajl'
require_relative 'two_word_dictionary'

# @private
class PersistentDictionary < TwoWordDictionary
  # Creates a PersistentDictionary object using the supplied dictionary file.
  #
  # @note Do not include the .mmd file extension in the name of the dictionary.
  #   It will be automatically appended.
  # @param [File] dictionary Name of dictionary file to create/open.
  # @return [Object] PersistentDictionary object.
  attr_reader :dictionarylocation
  def initialize(dictionary)
    @dictionarylocation = "#{dictionary}.mmd"
    self.open_dictionary
  end

  # Opens the dictionary objects dictionary file.
  # If the file exists it assigns the contents to a hash, 
  # otherwise it creates an empty hash.
  def open_dictionary
    if File.exists?(@dictionarylocation)
      File.open(@dictionarylocation,'r') do |f|
        @dictionary = Yajl::Parser.parse(f)
      end
    else
      @dictionary = {}
    end
  end

  # Saves the PersistentDictionary objects @dictionary hash 
  # to disk in JSON format.
  def save_dictionary!
    json = Yajl::Encoder.encode(@dictionary)
    File.open(@dictionarylocation, 'w') do |f|
      f.puts json
    end
    true
  end

  def self.delete_dictionary!(dictionary=@dictionarylocation[0...-4])
    mmd = "#{dictionary}.mmd"
    if File.exists?(mmd)
      File.delete(mmd)
      "Deleted #{mmd}"
    end
    false
  end
end
