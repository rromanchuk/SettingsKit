class String
  def camelize
    string = self
    string = string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub("/", "::")
  end
end

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
      enums = @settings.map { |key| "  case " + key.camelize }.join("\n")

      identifiers = @settings.map { |key|
        "      case .#{key.camelize}:\n        return \"#{key}\""
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

enum Settings: String, SettingsKit {
#{enums}

  var identifier: String {
    switch self {
#{identifiers}
    }
  }
}
swift
    end

  end
end
