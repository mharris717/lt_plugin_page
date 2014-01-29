require 'mharris_ext'
require 'open-uri'
require 'edn'

class Time
  def pretty
    strftime("%m/%d/%y")
  end

  class << self
    def from_java_time(num)
      sec = num / 1000
      start = Time.local(1970,1,1)
      start + sec
    end
  end
end

class String
  def pretty_list
    gsub(",","<br>").gsub("(","<br>(")
  end
end

class Plugin
  include FromHash
  attr_accessor :name, :installs, :author, :version, :source, :desc, :dependencies, :added, :updated

  def raw=(raw)
    [:name, :author, :version, :source, :desc].each do |sym|
      send("#{sym}=",raw[:info][sym])
    end

    self.installs = raw[:installs]

    self.added = Time.from_java_time(raw[:added])
    self.updated = Time.from_java_time(raw[:updated])
  end

  class << self
    fattr(:raw) { open("http://plugins.lighttable.com").read }
    fattr(:raw_local) do
      File.read("plugins.edn").force_encoding("ASCII-8BIT")
    end
    fattr(:all) do
      EDN.read(raw).map do |row|
        new(raw: row)
      end
    end
  end
end
