require "../../spec_helper"
require "./test_classes"

class TestChild
  include KDL::Serializable

  @[KDL::Argument]
  property value : String
end

describe KDL::Serializable do
  it "serializes documents" do
    doc = KDL.parse <<-KDL
    TestNode "arg1" #true 1 22 333 foo="a" bardle="b" baz="c" qux="d" {
      norf wat
      thing foo
      thing bar
      thing baz
      path "some/path"
      path "some/other/path"
      arg arg2
      args x y z
      props a=x b=y c=z
      feature florp enabled=#true option=42
      dashies {
        - Lorem
        - Ipsum
      }
      thangs {
        - qux
        - norf
      }
    }
    KDL

    obj = TestNode.from_kdl(doc.nodes[0])
    obj.first.should eq "arg1"
    obj.second.should eq true
    obj.numbers.should eq [1, 22, 333]
    obj.foo.should eq "a"
    obj.bar.should eq "b"
    obj.map.should eq({"baz" => "c", "qux" => "d"})
    obj.arg.should eq "arg2"
    obj.args.should eq ["x", "y", "z"]
    obj.props.should eq({"a" => "x", "b" => "y", "c" => "z"})
    obj.feature_name.should eq("florp")
    obj.feature_enabled.should eq(true)
    obj.feature_option.should eq(42_u64)
    obj.dashies.should eq(["Lorem", "Ipsum"])
    obj.norf.value.should eq "wat"
    obj.things.size.should eq 3
    obj.things[0].value.should eq "foo"
    obj.things[1].value.should eq "bar"
    obj.things[2].value.should eq "baz"
    obj.thangs.size.should eq 2
    obj.thangs[0].value.should eq "qux"
    obj.thangs[1].value.should eq "norf"
    obj.paths.should eq ["some/path", "some/other/path"]

    KDL::Document.new([obj.to_kdl]).should eq doc
  end

  describe "default value" do
    it "serializes missing argument" do
      doc = KDL.parse <<-KDL
      missing
    KDL

      obj = MissingArgumentWithDefault.from_kdl doc
      obj.missing.should eq "default"
    end

    it "serializes missing node" do
      doc = KDL.parse <<-KDL
      KDL

      obj = MissingArgumentWithDefault.from_kdl doc
      obj.missing.should eq "default"
    end

    it "serializes missing nested node" do
      doc = KDL.parse <<-KDL
      KDL

      obj = NestedMissingArgumentWithDefault.from_kdl doc
      obj.missing.should be_a MissingArgumentWithDefault
      obj.missing.missing.should eq "default"
    end
  end

  describe "nilable" do
    it "serializes missing argument" do
      doc = KDL.parse <<-KDL
        missing
      KDL

      obj = MissingArgumentWithNilable.from_kdl doc
      obj.missing.should eq nil
    end

    it "serializes missing node" do
      doc = KDL.parse <<-KDL
      KDL

      obj = MissingArgumentWithNilable.from_kdl doc
      obj.missing.should eq nil
    end

    it "serializes missing nested node" do
      doc = KDL.parse <<-KDL
      KDL

      obj = NestedMissingArgumentWithNilable.from_kdl doc
      obj.missing.should be nil
    end
  end

  describe "no default value" do
    it "raises exception for missing argument" do
      doc = KDL.parse <<-KDL
        missing
      KDL

      expect_raises(KDL::SerializableException) do
        MissingArgumentWithoutDefault.from_kdl doc
      end
    end

    it "raises exception for missing node" do
      doc = KDL.parse <<-KDL
      KDL

      expect_raises(KDL::SerializableException) do
        MissingArgumentWithoutDefault.from_kdl doc
      end
    end

    it "raises exception for missing nested node" do
      doc = KDL.parse <<-KDL
        missing {
        }
      KDL

      expect_raises(KDL::SerializableException) do
        NestedMissingArgumentWithoutDefault.from_kdl doc
      end
    end
  end
end
