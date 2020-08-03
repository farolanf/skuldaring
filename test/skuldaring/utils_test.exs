defmodule Skuldaring.UtilsTest do
  use Skuldaring.DataCase, async: true

  import Skuldaring.Utils

  describe "utils" do

    test "get_breadcrumbs" do
      paths = [
        {"/", "Beranda"},
        {"/akun", "Akun"},
        {"/sekolah", "Sekolah"},
        {"/sekolah/[^/]+/murid", "Murid Sekolah"},
      ]
      breadcrumbs = get_breadcrumbs("/sekolah/rahayu/murid", paths)
      assert ^breadcrumbs = [
        {"/", "Beranda"},
        {"/sekolah", "Sekolah"},
        "Murid Sekolah",
      ]
    end

  end

end
