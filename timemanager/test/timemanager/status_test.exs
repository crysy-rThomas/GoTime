defmodule Timemanager.StatusTest do
  use Timemanager.DataCase

  alias Timemanager.Status

  describe "status" do
    alias Timemanager.Status.Stat

    import Timemanager.StatusFixtures

    @invalid_attrs %{title: nil}

    test "list_status/0 returns all status" do
      stat = stat_fixture()
      assert Status.list_status() == [stat]
    end

    test "get_stat!/1 returns the stat with given id" do
      stat = stat_fixture()
      assert Status.get_stat!(stat.id) == stat
    end

    test "create_stat/1 with valid data creates a stat" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Stat{} = stat} = Status.create_stat(valid_attrs)
      assert stat.title == "some title"
    end

    test "create_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Status.create_stat(@invalid_attrs)
    end

    test "update_stat/2 with valid data updates the stat" do
      stat = stat_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Stat{} = stat} = Status.update_stat(stat, update_attrs)
      assert stat.title == "some updated title"
    end

    test "update_stat/2 with invalid data returns error changeset" do
      stat = stat_fixture()
      assert {:error, %Ecto.Changeset{}} = Status.update_stat(stat, @invalid_attrs)
      assert stat == Status.get_stat!(stat.id)
    end

    test "delete_stat/1 deletes the stat" do
      stat = stat_fixture()
      assert {:ok, %Stat{}} = Status.delete_stat(stat)
      assert_raise Ecto.NoResultsError, fn -> Status.get_stat!(stat.id) end
    end

    test "change_stat/1 returns a stat changeset" do
      stat = stat_fixture()
      assert %Ecto.Changeset{} = Status.change_stat(stat)
    end
  end
end
