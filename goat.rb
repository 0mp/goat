#!/usr/bin/env ruby

require 'yaml'

module Goat
    FILE_PATH = ENV['HOME'] + "/.goat/config/shortcuts.yml"
    @@path_from_alias = {}

    module_function

    def act(args)
        if args.size == 1
            go(args[0])
        elsif args.size == 2
            add_path(args[0], args[1])
        else
            raise "Usage: goat <alias/destination> [path]"
        end
    end

    def add_path(path_alias, path)
        absolute_path = File.expand_path(path)
        raise 'Wrong path.' unless File.exist?(absolute_path)
        raise 'This is not a directory.' unless File.directory?(absolute_path)
        @@path_from_alias[path_alias] = absolute_path
    end

    def initialize
        File.open(FILE_PATH, "a")
    end

    def go(destination)
        if @@path_from_alias[destination] == nil
            raise 'Wrong destination.'
        end
        puts @@path_from_alias[destination]
    end

    def load
        @@path_from_alias = YAML.load_file(FILE_PATH) || {}
    end

    def save
        File.open(FILE_PATH, "w") do |file|
            file.write @@path_from_alias.to_yaml
        end
    end
end

Goat.initialize
Goat.load
Goat.act(ARGV)
Goat.save

