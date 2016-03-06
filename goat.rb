#!/usr/bin/env ruby

require 'yaml'

load "settings.rb"

module Goat
    module_function

    def initialize
        File.open(ALIAS_TO_PATH_HASH_FILE_PATH, "w")
    end

end

Goat::initialize
Goat::load

