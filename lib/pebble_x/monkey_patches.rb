require 'xcodeproj'
require 'xcodeproj/scheme'

class Xcodeproj::XCScheme::XML_Fromatter
  def write_element(node, output)
    @indentation = 3
    output << ' '*@level
    output << "<#{node.expanded_name}"

    @level += @indentation
    node.attributes.each_attribute do |attr|
      output << "\n"
      output << ' '*@level
      output << attr.to_string.sub(/=/, ' = ') # here's the patch (sub instead of gsub)
    end unless node.attributes.empty?

    output << ">"

    output << "\n"
    node.children.each { |child|
      next if child.kind_of?(REXML::Text) and child.to_s.strip.length == 0
      write(child, output)
      output << "\n"
    }
    @level -= @indentation
    output << ' '*@level
    output << "</#{node.expanded_name}>"
  end
end


class Xcodeproj::XCScheme
  alias construct_buildable_name_without_legacy_target construct_buildable_name

  def construct_buildable_name_with_legacy_target(build_target)
    if build_target.is_a? Xcodeproj::Project::Object::PBXLegacyTarget
      build_target.name
    else
      construct_buildable_name_without_legacy_target build_target
    end
  end

  alias construct_buildable_name construct_buildable_name_with_legacy_target

end