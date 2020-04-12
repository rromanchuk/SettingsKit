module SettingsKit
  class Renderer

    def initialize(settings)
      @settings = settings
    end

    def render(output_path)
      puts "SettingsKit: Rendering Settings.swift..."
      swift = generate()

      outfile = File.open(output_path, "w")
      outfile.write(swift)
      outfile.close

      Integrator.new(output_path)
    end

    def generate
      enums = @settings.map { |key| "  case " + key.camelcase }.join("\n")

      identifiers = @settings.map { |key|
        "      case .#{snake_to_studly(key)}:\n        return \"#{key}\""
      }.join("\n")

<<-swift
//
//  Settings.swift
//  Auto-generated settings manifest file,
//  for use with SettingsKit. If you need to make changes,
//  edit the Settings.bundle and build the project.
//
//  Any manual changes to this file will be overwritten at build time.
//
//  Generated by the SettingsKit build tool on 2/29/16.
//
import SettingsKit

enum Settings: SettingsKit {
#{enums}

  var identifier: String {
    switch self {
#{identifiers}
    }
  }
}
swift
    end

    def snake_to_camel(string)
      string.split("_").map.with_index { |word, index| 
        index == 0 ? word.capitalize : word.downcase
      }.join
    end

  end
end
