defmodule Skuldaring.UtilsTest do
  use Skuldaring.DataCase, async: true

  alias Skuldaring.Utils

  describe "utils" do

    test "get_breadcrumbs" do
      paths = [
        {"/", "Beranda"},
        {"/akun", "Akun"},
        {"/sekolah", "Sekolah"},
        {"/sekolah/[^/]+/murid", "Murid Sekolah"},
      ]
      breadcrumbs = Utils.get_breadcrumbs("/sekolah/rahayu/murid", paths)
      assert ^breadcrumbs = [
        {"/", "Beranda"},
        {"/sekolah", "Sekolah"},
        "Murid Sekolah",
      ]
    end

    test "params_order/1" do
      order = ["name", age: :desc]
      result = Utils.params_order(order)
      assert [asc: :name, desc: :age] = result
    end

  end

end
