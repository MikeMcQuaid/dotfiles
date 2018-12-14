#!/usr/bin/env ruby

require "pathname"
require "fileutils"

@rbenv_versions         = Pathname("#{ENV["HOME"]}/.rbenv/versions")
homebrew_ruby_versions  = Pathname.glob("/usr/local/Cellar/ruby")
homebrew_ruby_versions += Pathname.glob("/usr/local/Cellar/ruby@*")

def link_rbenv_version_without_revision(version)
  basename_without_revision = version.basename
                                     .to_s
                                     .gsub(/_\d+$/, "")
  FileUtils.ln_sf version, @rbenv_versions / basename_without_revision
end

def gem_like_version(version)
  Gem::Version.new(version.basename
                          .to_s
                          .tr("_", "."))
end

@rbenv_versions.mkpath

homebrew_ruby_versions.flat_map(&:children)
                      .sort_by(&method(:gem_like_version))
                      .each(&method(:link_rbenv_version_without_revision))

@rbenv_versions.children
               .select(&:symlink?)
               .reject(&:exist?)
               .each { |path| FileUtils.rm_f path }
