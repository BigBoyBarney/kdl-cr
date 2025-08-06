class TestNode
  include KDL::Serializable

  @[KDL::Argument]
  property first : String

  @[KDL::Argument]
  property second : Bool

  @[KDL::Arguments]
  property numbers : Array(UInt32)

  @[KDL::Property]
  property foo : String

  @[KDL::Property(name: "bardle")]
  property bar : String

  @[KDL::Properties]
  property map : Hash(String, String)

  @[KDL::Child(unwrap: "argument")]
  property arg : String

  @[KDL::Child(unwrap: "arguments")]
  property args : Array(String)

  @[KDL::Child(unwrap: "properties")]
  property props : Hash(String, String)

  @[KDL::Child(name: "feature", unwrap: "argument")]
  property feature_name : String

  @[KDL::Child(name: "feature", unwrap: "property", property_name: "enabled")]
  property feature_enabled : Bool

  @[KDL::Child(name: "feature", unwrap: "property", property_name: "option")]
  property feature_option : UInt32

  @[KDL::Child(unwrap: "dash_vals")]
  property dashies : Array(String)

  @[KDL::Child]
  property norf : TestChild

  @[KDL::Children(name: "thing")]
  property things : Array(TestChild)

  @[KDL::Child(unwrap: "children")]
  property thangs : Array(TestChild)

  @[KDL::Children(name: "path", unwrap: "argument")]
  property paths : Array(String)
end

class MissingArgumentWithDefault
  include KDL::Serializable

  @[KDL::Child(unwrap: "argument")]
  property missing : String = "default"
end

class MissingArgumentWithNilable
  include KDL::Serializable

  @[KDL::Child(unwrap: "argument")]
  property missing : String?
end

class MissingArgumentWithoutDefault
  include KDL::Serializable

  @[KDL::Child(unwrap: "argument")]
  property missing : String
end
